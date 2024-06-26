import 'dart:convert';

import 'package:memo_app_flutter/data/http.dart';
import 'package:memo_app_flutter/types/type.dart';

Future<MemoDetailType?> postAddMemo(MemoDetailType data) async {
  Map<String, dynamic> jsonData = {
    'id': data.id,
    'name': data.name,
    'tag': data.tag,
    'tasks': data.tasks,
  };
  final response =
      await clientRequest('/add-memo', method: 'POST', data: jsonData);

  if (response.statusCode == 200) {
    dynamic jsonData = json.decode(response.body);
    MemoDetailType memo = MemoDetailType.fromJson(jsonData);
    return memo;
  } else {
    throw Exception('Failed to post data');
  }
}
