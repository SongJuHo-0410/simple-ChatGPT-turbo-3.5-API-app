import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  String _message = '';

  Future<void> _submitForm() async {
    final url = Uri.parse('https://songjuho.pythonanywhere.com/chat');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user': _controller.text}),
    );
    final responseData = json.decode(response.body);
    setState(() {
      _message = responseData['message'];
    });
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
              Text(_message),
            ],
          ),
        ),
      ),
    );
  }
}
