import 'dart:convert';

import 'package:http/http.dart' as http;

clientRequest(String path,
    {String method = 'GET', Map<String, dynamic>? data}) {
  var uri = Uri.parse('http://35.233.218.140$path');
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
