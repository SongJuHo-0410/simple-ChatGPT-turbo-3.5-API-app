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
- `onReceiveAnswer` (함수(List)): 응답을 받을 때 호출될 콜백 함수입니다.

#### 반환값

`Future<void>` 객체입니다.

## 사용 예제

```dart
import 'api_services.dart';

void main() async {
  final chatModule = ChatModule();

  await chatModule.sendChatMessage('안녕하세요', '잘 지내시나요?', (List result) {
    final answer = result[0];
    final summary = result[1];
    print('답변: $answer');
    print('요약: $summary');
  });
}
```

# 서버 API

이 저장소에는 Flask를 사용하여 GPT-3.5-turbo 모델과의 채팅 상호작용을 다루기 위한 `server_api.py` 파일이 포함되어 있습니다.

## 의존성

서버를 실행하기 위해 다음 의존성이 필요합니다:

- `json`: JSON 데이터 처리를 위한 라이브러리
- `Flask`: 웹 애플리케이션 프레임워크
- `openai`: OpenAI API와의 상호 작용을 위한 라이브러리
- `os`: 환경 변수 설정을 위한 라이브러리

## 설정

서버를 실행하기 전에 OpenAI API 키를 설정해야 합니다. `openai.api_key` 변수에 키를 할당하여 설정할 수 있습니다.

## 엔드포인트

### POST /chat

이 엔드포인트를 통해 클라이언트는 채팅 메시지를 보내고 GPT-3.5-turbo 모델로부터 응답을 받을 수 있습니다.

#### 요청

- 헤더:
  - `Content-Type: application/json`

- 바디:
  - `system` (문자열): 시스템 입력 메시지
  - `user` (문자열): 사용자 입력 메시지

#### 응답

- 바디:
  - `answer` (문자열): 모델이 생성한 응답
  - `summary` (문자열): 대화 요약

## 사용 예시

API를 사용하려면 `/chat` 엔드포인트로 POST 요청을 보내고, 요청 바디에 시스템과 사용자 입력 메시지를 포함시키면 됩니다. 서버는 응답으로 생성된 응답과 대화 요약을 반환합니다.

```bash
POST /chat
Content-Type: application/json

{
  "system": "시스템 메시지",
  "user": "사용자 메시지"
}
```
