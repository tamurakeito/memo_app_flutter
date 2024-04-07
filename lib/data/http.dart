import 'package:http/http.dart' as http;

clientRequest(String path) {
  final response = http.get(Uri.parse('http://35.233.218.140$path'));
  return response;
}
