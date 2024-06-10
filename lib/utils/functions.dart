import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/data/api/get_client_data.dart';
import 'package:memo_app_flutter/data/api/get_memo_detail.dart';
import 'package:memo_app_flutter/data/api/get_memo_summary.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';

Future<MemoDetailType> fetchMemoDetail(
    WidgetRef ref, int index, int id, int page) async {
  MemoDetailType? memo;
  await getMemoDetail(id).then((data) {
    memo = data;
    ref.read(memoDetailsProvider.notifier).state[index] = data;
    if (page == index) {
      ref.read(memoProvider.notifier).state = MemoSummaryType(
        id: data.id,
        name: data.name,
        tag: data.tag,
        length: data.tasks.length,
      );
    }
  }).catchError((error) {
    print("Error fetching data1: $error");
  });
  return memo ?? MemoDetailType(id: 0, name: '', tag: false, tasks: []);
}

Future<List<MemoSummaryType>> fetchMemoSummaries(WidgetRef ref) async {
  try {
    final summaries = await getMemoSummary();
    final sortedList = [
      ...summaries.where((element) => element.tag).toList().reversed,
      ...summaries.where((element) => !element.tag).toList().reversed,
    ];
    ref.read(memoSummariesProvider.notifier).state = sortedList;
    setMemoDetails(ref, sortedList);
    return sortedList;
  } catch (error) {
    print("Error fetching data2: $error");
    return [];
  }
}

void setMemoDetails(WidgetRef ref, List<MemoSummaryType> sortedList) {
  final list = ref.watch(memoDetailsProvider);
  final MemoDetailType nullMemo =
      MemoDetailType(id: 0, name: '', tag: false, tasks: []);
  if (list.isEmpty) {
    ref.read(memoDetailsProvider.notifier).state =
        List.filled(sortedList.length, nullMemo);
  } else {
    ref.read(memoDetailsProvider.notifier).state = sortedList
        .map((e) => list.firstWhere((element) => element.id == e.id,
            orElse: () => nullMemo))
        .toList();
  }
}

Future<void> fetchNewMemoSummaries(WidgetRef ref) async {
  try {
    final summaries = await fetchMemoSummaries(ref);
    // ref.read(memoPageProvider.notifier).state = summaries.length - 1;
  } catch (error) {
    print("Error fetching data: $error");
  }
}
