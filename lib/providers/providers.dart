import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:memo_app_flutter/types/type.dart';

final isMenuOpenProvider = StateProvider<bool>((ref) => false);
final isTopModalOpenProvider = StateProvider<bool>((ref) => false);
final isBottomModalOpenProvider = StateProvider<bool>((ref) => false);

final memoProvider = StateProvider<MemoSummaryType?>((ref) => null);

final memoListProvider = StateProvider<List<MemoSummaryType>>(
  (ref) => [
    MemoSummaryType(id: 0, name: "メモA", tag: false, length: 5),
    MemoSummaryType(id: 0, name: "メモB", tag: false, length: 2),
    MemoSummaryType(id: 0, name: "メモC", tag: false, length: 0),
    MemoSummaryType(id: 0, name: "メモD", tag: false, length: 8),
  ],
);

final memoPageProvider = StateProvider<int>((ref) => 0);

final isLoadingProvider = StateProvider<bool>((ref) => false);
