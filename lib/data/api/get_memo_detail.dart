import 'package:http/http.dart' as http;
import 'package:memo_app_flutter/data/http.dart';
import 'dart:convert';

import 'package:memo_app_flutter/types/type.dart';

Future<MemoDetailType> getMemoDetail(int id) async {
  final response = await clientRequest('/memo-detail/$id');

  if (response.statusCode == 200) {
    dynamic jsonData = json.decode(response.body);
    // jsonDataをMemoSummaryのリストに変換
    MemoDetailType memo = MemoDetailType.fromJson(jsonData);
    return memo;
  } else {
    throw Exception('Failed to load post');
  }
}
