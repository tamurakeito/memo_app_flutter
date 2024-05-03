import 'package:memo_app_flutter/data/http.dart';
import 'package:memo_app_flutter/types/type.dart';

Future<void> deleteMemo(int id) async {
  final response = await clientRequest('/delete-memo/$id', method: 'DELETE');

  if (response.statusCode == 200) {
    print("Data successfully post");
  } else {
    throw Exception('Failed to delete data');
  }
}
