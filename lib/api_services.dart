import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpModule {
  static Future<http.Response> sendJsonPostRequest(
      String url, dynamic systemInput, dynamic userInput) async {
    // request body 생성
    Map<String, dynamic> msg = {
      'system': jsonEncode(systemInput),
      'user': jsonEncode(userInput)
    };
    String body = json.encode(msg);

    // request header 설정
    final headers = {'Content-Type': 'application/json'};

    // POST 요청 보내기
    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    return response;
  }
}

class ChatModule {
  // 채팅 메시지 전송 메서드
  Future<void> sendChatMessage(String systemMessage, String userMessage,
      Function(List) onReceiveAnswer) async {
    // API endpoint URL 설정
    const url = 'Your web site /chat';

    // request body 생성
    final systemInput = {'system': systemMessage};
    final userInput = {'user': userMessage};

    // POST 요청 보내기
    final response =
        await HttpModule.sendJsonPostRequest(url, systemInput, userInput);

    // response body 파싱
    final responseData = json.decode(response.body);
    final result = [responseData['answer'], responseData['summary']];

    // 콜백 함수 호출하여 결과 전달
    onReceiveAnswer(result);
  }
}
