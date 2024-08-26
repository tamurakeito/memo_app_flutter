import 'dart:ffi';

import 'package:memo_app_flutter/data/http.dart';
import 'package:memo_app_flutter/types/type.dart';

Future<void> putMemoOrderOverride(List<int> data) async {
  Map<String, dynamic> jsonData = {
    'order': data,
  };
  final response = await clientRequest('/memo-order-override',
      method: 'PUT', data: jsonData);

  if (response.statusCode == 200) {
    print("Data successfully memo order override");
  } else {
    throw Exception('Failed to update data');
  }
}
