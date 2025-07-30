import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

class AuthHeaderTestScreen extends StatefulWidget {
  const AuthHeaderTestScreen({super.key});

  @override
  State<AuthHeaderTestScreen> createState() => _AuthHeaderTestScreenState();
}

class _AuthHeaderTestScreenState extends State<AuthHeaderTestScreen> {
  final TextEditingController _headerController = TextEditingController();
  String _result = '';
  bool _error = false;

  void _parseToken() {
    final input = _headerController.text.trim();
    setState(() {
      try {
        final token =
            AortemMagicAuthHeaderParse.parseAuthorizationHeader(input);
        _result = '✅ Extracted Token:\n\n$token';
        _error = false;
      } catch (e) {
        _result = '❌ Error:\n\n$e';
        _error = true;
      }
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parse Authorization Header')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _headerController,
              decoration: const InputDecoration(
                labelText: 'Authorization Header',
                hintText: 'e.g. Bearer abc123XYZ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _parseToken,
              child: const Text('Parse Token'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _error ? Colors.red.shade50 : Colors.green.shade50,
                  border: Border.all(
                    color: _error ? Colors.red : Colors.green,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _result,
                  style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
