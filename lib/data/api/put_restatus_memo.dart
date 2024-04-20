import 'package:memo_app_flutter/data/http.dart';
import 'package:memo_app_flutter/types/type.dart';

Future<void> putRestatusMemo(MemoSummaryType data) async {
  Map<String, dynamic> jsonData = {
    'id': data.id,
    'name': data.name,
    'tag': data.tag,
    'length': data.length,
  };
  final response =
      await clientRequest('/restatus-memo', method: 'PUT', data: jsonData);

  if (response.statusCode == 200) {
    print("Data successfully updated");
  } else {
    throw Exception('Failed to update data');
  }
}
