import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpModule {
  static Future<http.Response> sendJsonPostRequest(String url, dynamic systemInput, dynamic userInput) async {
    // request body 생성
    Map<String, dynamic> msg = {'system': jsonEncode(systemInput), 'user': jsonEncode(userInput)};

    // requst dody 설정
    String body = json.encode(msg);

    // request header 설정
    final headers = {'Content-Type': 'application/json'};

    // POST 요청 보내기
    final response = await http.post(Uri.parse(url), headers: headers, body: body);
    return response;
  }
}

class ChatModule {
  // 채팅 메시지 전송 메서드
  static Future<List> sendChatMessage(String systemMessage, String userMessage) async {
    // API endpoint URL 설정
    // const url = 'http://chat.openai.com/chat';
    const url = 'http://songjuho.pythonanywhere.com/chat';

    // request body 생성
    final systemInput = {'system': systemMessage};
    final userInput = {'user': userMessage};
    // POST 요청 보내기
    final response = await HttpModule.sendJsonPostRequest(url, systemInput, userInput);

    // response body 파싱
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final result = [responseData['answer'], responseData['summary']];

      return result;
    } else {
      throw Exception('응답을 파싱하는 동안 오류가 발생했습니다. 상태 코드: ${response.statusCode}');
    }
  }
}
