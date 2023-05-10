import 'http_module.dart';
import 'dart:convert';

Future<void> sendChatMessage(
    String userMessage, Function(String) onReceiveMessage) async {
  const url = 'https://songjuho.pythonanywhere.com/chat';
  final data = {'user': userMessage};
  final response = await sendJsonPostRequest(url, data);
  final responseData = json.decode(response.body);
  final message = responseData['message'];
  onReceiveMessage(message);
}
