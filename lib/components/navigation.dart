import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:memo_app_flutter/accessories/atomic_border.dart';
import 'package:memo_app_flutter/components/skeleton_navigation.dart';
import 'package:memo_app_flutter/components/sortable_list.dart';
import 'package:memo_app_flutter/data/api/post_add_memo.dart';
import 'package:memo_app_flutter/data/api/put_memo_order_override.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_circle.dart';
import 'package:memo_app_flutter/ui/atoms/atomic_text.dart';
import 'package:memo_app_flutter/ui/atoms/button.dart';
import 'package:memo_app_flutter/ui/molecules/loading_circle.dart';
import 'package:memo_app_flutter/utils/functions.dart';
import 'package:memo_app_flutter/utils/style.dart';

class Navigation extends HookConsumerWidget {
  final WidgetRef homeRef;
  const Navigation({super.key, required this.homeRef});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<MemoSummaryType> list = ref.watch(memoSummariesProvider);
    final int page = ref.watch(memoPageProvider);
    final ValueNotifier<bool> isAddMemo = useState(false);
    FocusNode myFocusNode = FocusNode();
    useEffect(() {
      if (isAddMemo.value) myFocusNode.requestFocus();
    }, [isAddMemo.value]);

    final isSyncActive = useState<bool>(false);
    final loadingFlag = useState<bool>(false);
    final isLoading = useState<bool>(false);
    Future<void> fetch() async {
      ref.read(isLoadingProvider.notifier).state = true;
      isLoading.value = true;
      await fetchMemoSummaries(ref).whenComplete(() {
        ref.read(isLoadingProvider.notifier).state = false;
        isLoading.value = false;
      });
    }

    final order = [
      ...list
          .where((element) => element.tag)
          .toList()
          .map((item) => item.id)
          .toList(),
      ...list
          .where((element) => !element.tag)
          .toList()
          .map((item) => item.id)
          .toList()
    ];

    return Drawer(
      child: Container(
        color: kWhite,
        child: Stack(
          children: [
            !isLoading.value
                ? GestureDetector(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollStartNotification) {
                          // isSyncActive.value = true;
                        }
                        if (notification.metrics.pixels < -50) {
                          isSyncActive.value = true;
                          loadingFlag.value = true;
                        } else if (notification.metrics.pixels > -50) {
                          isSyncActive.value = false;
                        }
                        if (notification is ScrollEndNotification) {
                          if (loadingFlag.value) {
                            loadingFlag.value = false;
                            fetch();
                          }
                        }
                        return false;
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          margin: const EdgeInsets.only(top: 100),
                          constraints: BoxConstraints(
                            minHeight: screenHeight(context) -
                                100, // Containerの最小高さを設定
                          ),
                          decoration: const BoxDecoration(
                              border: Border(top: AtomicBorder())),
                          child: Column(
                            children: [
                              MemoListBox(
                                isTagged: true,
                                memoList: list
                                    .where((element) => element.tag)
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  MemoSummaryType memo = entry.value;
                                  return MemoListBlock(
                                    text: memo.name,
                                    length: memo.length,
                                    isFocused:
                                        page == index && !isAddMemo.value,
                                    jumpPage: index,
                                  );
                                }).toList(),
                                order: order,
                              ),
                              MemoListBox(
                                isTagged: false,
                                memoList: list
                                    .where((memo) => !memo.tag)
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key +
                                      list
                                          .where((element) => element.tag)
                                          .length;
                                  MemoSummaryType memo = entry.value;
                                  return MemoListBlock(
                                    text: memo.name,
                                    length: memo.length,
                                    isFocused:
                                        page == index && !isAddMemo.value,
                                    jumpPage: index,
                                  );
                                }).toList(),
                                isAddMemo: isAddMemo,
                                myFocusNode: myFocusNode,
                                homeRef: homeRef,
                                order: order,
                                buffer:
                                    list.where((element) => element.tag).length,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : SkeletonNavigation(),
            Padding(
              padding: EdgeInsets.only(top: 75),
              child: LoadingCircle(
                isActive: isSyncActive.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MemoListBox extends HookConsumerWidget {
  final bool isTagged;
  final List<MemoListBlock> memoList;
  final ValueNotifier<bool>? isAddMemo;
  final FocusNode? myFocusNode;
  final WidgetRef? homeRef;
  final List<int> order;
  final int? buffer;
  const MemoListBox({
    super.key,
    required this.isTagged,
    required this.memoList,
    this.isAddMemo,
    this.myFocusNode,
    this.homeRef,
    required this.order,
    this.buffer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleExec(String value) async {
      if (value != '') {
        MemoDetailType data =
            MemoDetailType(id: 0, name: value, tag: false, tasks: []);
        await postAddMemo(data).then((data) async {
          final List<MemoSummaryType>? summaries =
              await fetchNewMemoSummaries(homeRef!);
          if (summaries != null) {
            final int index =
                summaries.indexWhere((summary) => summary.id == data!.id);
            ref.read(memoPageProvider.notifier).state = index;
          }
        }).catchError((error) {
          print("Error fetching data: $error");
        });
        await Future.delayed(Duration(milliseconds: 1));
      }
      Navigator.pop(context);
    }

    final TextEditingController textController = useTextEditingController();

    int pageId = order[ref.read(memoPageProvider)];
    Future<void> memoOrderOverride(List<int> data) async {
      putMemoOrderOverride(data).catchError((error) {}).whenComplete(() async {
        await fetchMemoSummaries(ref);
        ref.read(memoPageProvider.notifier).state = data.indexOf(pageId);
      });
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(21, 10, 17, 10),
            child: Row(
              children: [
                Icon(
                  isTagged ? Icons.bookmark : Icons.bookmark_border,
                  size: 19,
                  color: kGray700,
                ),
                const SizedBox(
                  width: 16,
                ),
                AtomicText(
                  isTagged ? "固定" : "リスト",
                  style: AtomicTextStyle.h4,
                  type: AtomicTextColor.light,
                ),
                Spacer(),
                if (!isTagged)
                  Button(
                    onPressed: () {
                      isAddMemo?.value = true;
                    },
                    child: Icon(
                      LineIcons.plus,
                      size: 19,
                      color: kGray700,
                    ),
                  ),
              ],
            ),
          ),
          if (!isTagged && isAddMemo?.value == true)
            Container(
              color: kGray100,
              padding: const EdgeInsets.fromLTRB(23, 0, 23, 0),
              child: Row(
                children: [
                  const AtomicCircle(
                    type: AtomicCircleType.gray,
                    radius: 6,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (text) {
                        if (textController.value.composing.isCollapsed) {
                          // 全角スペースを半角スペースに置き換え
                          textController.value = textController.value.copyWith(
                            text: text.replaceAll('　', ' '),
                            selection: TextSelection.collapsed(
                                offset: textController.selection.baseOffset),
                          );
                        }
                      },
                      onSubmitted: (String value) {
                        handleExec(value);
                      },
                      style: TextStyle(
                        fontFamily: 'NotoSansJP',
                        fontSize: kFontSizeHeadlineH5,
                        fontWeight: FontWeight.normal,
                        color: kBlack,
                      ),
                      decoration: InputDecoration(
                        hintText: '新しいメモ',
                        border: InputBorder.none, // 枠線なし
                        contentPadding: EdgeInsets.zero,
                      ),
                      focusNode: myFocusNode,
                    ),
                  ),
                  AtomicText('0', style: AtomicTextStyle.sm)
                ],
              ),
            ),
          // ...memoList/
          SortableList(
            items: memoList,
            height: 35,
            order: order,
            handler: memoOrderOverride,
            buffer: buffer,
          )
        ],
      ),
    );
  }
}

class MemoListBlock extends ConsumerWidget {
  final String text;
  final int length;
  final bool isFocused;
  final int jumpPage;
  const MemoListBlock({
    super.key,
    required this.text,
    required this.length,
    required this.isFocused,
    required this.jumpPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Button(
      onPressed: () {
        Navigator.pop(context);
        ref.read(memoPageProvider.notifier).state = jumpPage;
      },
      child: Container(
        color: isFocused ? kGray200 : kWhite,
        padding: const EdgeInsets.fromLTRB(23, 10, 23, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AtomicCircle(
              type: AtomicCircleType.gray,
              radius: 6,
            ),
            const SizedBox(
              width: 16,
            ),
            SizedBox(
              height: 12,
              child: AtomicText(text,
                  style: AtomicTextStyle.h5, type: AtomicTextColor.dark),
            ),
            const Spacer(),
            AtomicText(length.toString(), style: AtomicTextStyle.sm)
          ],
        ),
      ),
    );
  }
}
