import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response> sendJsonPostRequest(String url, dynamic data) async {
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(data),
  );
  return response;
}
