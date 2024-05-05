import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/types/type.dart';

final isMenuOpenProvider = StateProvider<bool>((ref) => false);
final isAddTaskModalOpenProvider = StateProvider<bool>((ref) => false);
final isRenameMemoModalOpenProvider = StateProvider<bool>((ref) => false);
final isBottomModalOpenProvider = StateProvider<bool>((ref) => false);

final memoProvider = StateProvider<MemoSummaryType?>((ref) => null);

final memoSummariesProvider = StateProvider<List<MemoSummaryType>>(
  (ref) => [],
);
final memoDetailsProvider = StateProvider<List<MemoDetailType>>(
  (ref) => [],
);

final memoPageProvider = StateProvider<int>((ref) => 0);

final isLoadingProvider = StateProvider<bool>((ref) => false);
