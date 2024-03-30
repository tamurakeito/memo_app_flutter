import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:memo_app_flutter/types/type.dart';

Future<List<MemoSummaryType>> fetchPost() async {
  final response =
      await http.get(Uri.parse('http://35.233.218.140/memo-summary'));

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
