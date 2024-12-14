import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

Future<http.Response> clientRequest(String path,
    {String method = 'GET', Map<String, dynamic>? data}) async {
  var uri = Uri.parse('http://34.146.93.87:8080$path');

  await Future.delayed(Duration(milliseconds: 500));

  switch (method.toUpperCase()) {
    case 'POST':
      return http.post(uri,
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
    case 'PUT':
      return http.put(uri,
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'});
    case 'DELETE':
      return http.delete(uri);
    case 'GET':
    default:
      return http.get(uri);
  }
}
