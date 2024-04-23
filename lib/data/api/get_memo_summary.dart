import 'package:memo_app_flutter/data/http.dart';
import 'dart:convert';

import 'package:memo_app_flutter/types/type.dart';

Future<List<MemoSummaryType>> getMemoSummary() async {
  final response = await clientRequest('/memo-summary');

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    // jsonDataをMemoSummaryのリストに変換
    List<MemoSummaryType> memos =
        jsonData.map((data) => MemoSummaryType.fromJson(data)).toList();
    return memos;
  } else {
    throw Exception('Failed to load post');
  }
}
