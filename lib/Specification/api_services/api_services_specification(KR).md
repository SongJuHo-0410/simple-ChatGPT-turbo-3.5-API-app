# API Services

이 저장소에는 `api_services.dart` 파일이 포함되어 있으며, HTTP 요청을 처리하는 모듈과 API 엔드포인트로 채팅 메시지를 전송하는 채팅 모듈을 제공합니다.

## HttpModule 클래스

`HttpModule` 클래스에는 JSON POST 요청을 보내는 메서드가 포함되어 있습니다.

### sendJsonPostRequest 메서드

지정된 URL로 JSON POST 요청을 보냅니다.

#### 매개변수

- `url` (문자열): API 엔드포인트의 URL입니다.
- `systemInput` (동적 타입): 시스템 입력 데이터입니다.
- `userInput` (동적 타입): 사용자 입력 데이터입니다.

#### 반환값

요청의 응답을 나타내는 `Future<http.Response>` 객체입니다.



## ChatModule 클래스

`ChatModule` 클래스는 채팅 메시지를 전송하고 API 엔드포인트로부터 응답을 받는 메서드를 제공합니다.

### sendChatMessage 메서드

채팅 메시지를 API 엔드포인트로 전송하고 응답을 받습니다.

#### 매개변수

- `systemMessage` (문자열): 시스템 메시지입니다.
- `userMessage` (문자열): 사용자 메시지입니다.

#### 반환값

`Future<void>` 객체입니다.

## 사용 예제

```dart
import 'api_services.dart';

void main() async {
  final result = await ChatModule.sendChatMessage('시스템 메시지', '사용자 메시지');
  final answer = result[0];
  final summary = result[1];
  print('응답: $answer');
  print('요약: $summary');
}
```