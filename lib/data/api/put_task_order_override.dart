import 'package:memo_app_flutter/data/http.dart';
import 'package:memo_app_flutter/types/type.dart';

Future<void> putTaskOrderOverride(TaskOrder data) async {
  Map<String, dynamic> jsonData = {
    'id': data.id,
    'order': data.order,
  };
  final response = await clientRequest('/task-order-override',
      method: 'PUT', data: jsonData);

  if (response.statusCode == 200) {
    // ignore: avoid_print
    print("Data successfully memo order override");
  } else {
    throw Exception('Failed to update data');
  }
}
