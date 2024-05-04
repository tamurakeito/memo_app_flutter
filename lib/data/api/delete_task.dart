import 'package:memo_app_flutter/data/http.dart';
import 'package:memo_app_flutter/types/type.dart';

Future<void> deleteTask(int id) async {
  final response = await clientRequest('/delete-task/$id', method: 'DELETE');

  if (response.statusCode == 200) {
    print("Data successfully post");
  } else {
    throw Exception('Failed to post data');
  }
}
