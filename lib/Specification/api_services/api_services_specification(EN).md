# API Services

This repository contains the `api_services.dart` file, which provides a module for handling HTTP requests and a chat module for sending chat messages to an API endpoint.

## HttpModule Class

The `HttpModule` class includes a method for sending a JSON POST request.

### sendJsonPostRequest Method

Sends a JSON POST request to a specified URL.

#### Parameters

- `url` (String): The URL of the API endpoint.
- `systemInput` (dynamic): The system input data.
- `userInput` (dynamic): The user input data.

#### Returns

A `Future<http.Response>` object representing the response of the request.

## ChatModule Class

The `ChatModule` class provides a method for sending chat messages and receiving responses from an API endpoint.

### sendChatMessage Method

Sends a chat message to the API endpoint and receives the answer.

#### Parameters

- `systemMessage` (String): The system message.
- `userMessage` (String): The user message.
- `onReceiveAnswer` (Function(List)): A callback function to receive the answer.

#### Returns

A `Future<void>` object.

## Example Usage

```dart
import 'api_services.dart';

void main() async {
  final chatModule = ChatModule();

  await chatModule.sendChatMessage('Hello', 'How are you?', (List result) {
    final answer = result[0];
    final summary = result[1];
    print('Answer: $answer');
    print('Summary: $summary');
  });
}
