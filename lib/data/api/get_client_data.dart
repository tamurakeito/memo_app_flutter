import 'package:memo_app_flutter/data/http.dart';
import 'dart:convert';

import 'package:memo_app_flutter/types/type.dart';

Future<ClientData> getClientData() async {
  final response = await clientRequest('/client-data');

  if (response.statusCode == 200) {
    dynamic jsonData = json.decode(response.body);
    // jsonDataをMemoSummaryのリストに変換
    ClientData data = ClientData.fromJson(jsonData);
    return data;
  } else {
    return ClientData(tab: 0);
  }
}
