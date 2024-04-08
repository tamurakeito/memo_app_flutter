import 'package:memo_app_flutter/data/http.dart';
import 'package:memo_app_flutter/types/type.dart';

Future<void> putClientData(ClientData data) async {
  Map<String, dynamic> jsonData = {
    'tab': data.tab,
  };
  final response = await clientRequest('/client-data-override',
      method: 'PUT', data: jsonData);

  if (response.statusCode == 200) {
    print("Data successfully updated");
  } else {
    throw Exception('Failed to update data');
  }
}
