import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/data/api/put_memo_order_override.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_circle.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/utils/functions.dart';
import 'package:memo_app_flutter/utils/style.dart';

final selectMemoProvider = StateProvider<int>((ref) => 0);

class SortableList extends HookConsumerWidget {
  final List<Widget> items;
  final double height;
  final List<int> order;
  final Future<void> Function(List<int>) handler;
  final int? buffer;
  const SortableList({
    super.key,
    required this.items,
    required this.height,
    required this.order,
    required this.handler,
    this.buffer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = useState<List<Widget>>(items);
    final isDragging = useState(false);
    final position = useState<double>(0);
    final selectIndex = useState(0);

    useEffect(() {
      list.value = items;
    }, [items]);

    Widget sortableItem(int index, Widget item) {
      return selectIndex.value == index && isDragging.value
          ? const SizedBox.shrink()
          : AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: selectIndex.value < index
                  ? position.value / height > index &&
                          position.value / height < index + 1 &&
                          isDragging.value
                      ? height * 2
                      : height
                  : position.value / height > index + 1 &&
                          position.value / height < index + 2 &&
                          isDragging.value
                      ? height * 2
                      : height,
              alignment: Alignment.topCenter,
              child: item,
            );
    }

    return GestureDetector(
      onLongPressStart: (LongPressStartDetails details) {
        isDragging.value = true;
        // ポジション取得
        position.value = details.localPosition.dy;
        // 選択したアイテムを取得する
        var index = (position.value / height).floor();
        selectIndex.value = index;
      },
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
        position.value = details.localPosition.dy;
        if (position.value < 0 || position.value > height * items.length) {
          isDragging.value = false;
        }
      },
      onLongPressEnd: (LongPressEndDetails details) async {
        if (isDragging.value) {
          isDragging.value = false;

          int index = (position.value / height).floor();
          int id = order.removeAt(selectIndex.value + (buffer ?? 0));
          order.insert(index + (buffer ?? 0), id);

          List<Widget> itemsClone = items;
          Widget item = itemsClone.removeAt(selectIndex.value);
          itemsClone.insert(index, item);
          list.value = itemsClone;

          handler(order);
        }
      },
      child: Stack(
        children: [
          Column(
            children: [
              !isDragging.value
                  ? const SizedBox.shrink()
                  : AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: position.value < height ? height : 0,
                    ),
              ...list.value
                  .asMap()
                  .entries
                  .map((entry) => sortableItem(entry.key, entry.value))
                  .toList(),
            ],
          ),
          isDragging.value
              ? Positioned(
                  top: position.value < height / 2
                      ? 0
                      : position.value > height * (items.length - 1 / 2)
                          ? height * (items.length - 1)
                          : position.value - (height / 2),
                  left: 0,
                  right: 0,
                  child: items[selectIndex.value],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
