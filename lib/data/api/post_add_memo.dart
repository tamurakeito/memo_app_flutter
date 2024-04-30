import 'package:memo_app_flutter/data/http.dart';
import 'package:memo_app_flutter/types/type.dart';

Future<void> postAddMemo(MemoDetailType data) async {
  Map<String, dynamic> jsonData = {
    'id': data.id,
    'name': data.name,
    'tag': data.tag,
    'tasks': [],
  };
  final response =
      await clientRequest('/add-memo', method: 'POST', data: jsonData);

  if (response.statusCode == 200) {
    print("Data successfully post");
  } else {
    throw Exception('Failed to post data');
  }
}
