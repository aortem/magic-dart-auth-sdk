import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart'; // Adjust if needed

class MagicConstructorScreen extends StatefulWidget {
  const MagicConstructorScreen({super.key});

  @override
  State<MagicConstructorScreen> createState() => _MagicConstructorScreenState();
}

class _MagicConstructorScreenState extends State<MagicConstructorScreen> {
  final TextEditingController _apiKeyController = TextEditingController(
    text: 'your-valid-api-key', // default test key
  );

  String _result = 'Idle...';

  void _initializeSdk() {
    final apiKey = _apiKeyController.text.trim();
    try {
      final magic = AortemMagicAuth(apiKey);
      setState(() {
        _result = '✅ SDK initialized with API key: ${magic.apiKey}';
      });
    } catch (e) {
      setState(() {
        _result = '❌ Failed to initialize SDK:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MagicAuth Constructor')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter API Key:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your API key',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeSdk,
              child: const Text('🚀 Initialize SDK'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Result:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SelectableText(_result),
          ],
        ),
      ),
    );
  }
}
