import 'package:memo_app_flutter/data/http.dart';

Future<void> putMemoOrderOverride(List<int> data) async {
  Map<String, dynamic> jsonData = {
    'order': data,
  };
  final response = await clientRequest('/memo-order-override',
      method: 'PUT', data: jsonData);

  if (response.statusCode == 200) {
    // ignore: avoid_print
    print("Data successfully memo order override");
  } else {
    throw Exception('Failed to update data');
  }
}
