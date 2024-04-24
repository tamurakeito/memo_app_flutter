import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/data/api/get_client_data.dart';
import 'package:memo_app_flutter/data/api/get_memo_detail.dart';
import 'package:memo_app_flutter/data/api/get_memo_summary.dart';
import 'package:memo_app_flutter/providers/providers.dart';
import 'package:memo_app_flutter/types/type.dart';

Future<void> fetchMemoDetail(WidgetRef ref, int index, int id) async {
  getMemoDetail(id).then((data) {
    ref.read(memoDetailsProvider.notifier).state[index] = data;
  }).catchError((error) {
    print("Error fetching data: $error");
  });
}

Future<List<MemoSummaryType>> fetchMemoSummaries(WidgetRef ref) async {
  try {
    final summaries = await getMemoSummary();
    final sortedList = [
      ...summaries.where((element) => element.tag),
      ...summaries.where((element) => !element.tag),
    ];
    ref.read(memoSummariesProvider.notifier).state = sortedList;
    return sortedList;
  } catch (error) {
    print("Error fetching data: $error");
    return [];
  }
}
