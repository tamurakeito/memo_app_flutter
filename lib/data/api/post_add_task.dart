import 'package:memo_app_flutter/data/http.dart';
import 'package:memo_app_flutter/types/type.dart';

Future<void> postAddTask(TaskType data) async {
  Map<String, dynamic> jsonData = {
    'id': data.id,
    'name': data.name,
    'memo_id': data.memoId,
    'complete': data.complete,
  };
  final response =
      await clientRequest('/add-task', method: 'POST', data: jsonData);

  if (response.statusCode == 200) {
    print("Data successfully post");
  } else {
    throw Exception('Failed to post data');
  }
}
