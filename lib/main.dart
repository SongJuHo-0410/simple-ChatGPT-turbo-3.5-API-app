import 'package:flutter/material.dart';
import 'package:test2/api_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My App',
      home: HelloPage(),
    );
  }
}

class HelloPage extends StatefulWidget {
  const HelloPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HelloPageState createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  String _answer = '';
  String _summary = '';
  String systemMessage = 'user: 안녕하세요 ai: 안녕하세요. 어떻게 도와드릴까요?';

  Future<void> _submitForm() async {
    final userMessage = _controller.text;
    final List<dynamic> result =
        await ChatModule.sendChatMessage(systemMessage, userMessage);
    _answer = result[0];
    _summary = result[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEST'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: '질문',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return '질문을 작성해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _submitForm();
                  }
                },
                child: const Text('SEND'),
              ),
              const SizedBox(height: 16.0),
              Text('$_answer \n $_summary'),
            ],
          ),
        ),
      ),
    );
  }
}
