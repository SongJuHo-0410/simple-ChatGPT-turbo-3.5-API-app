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
