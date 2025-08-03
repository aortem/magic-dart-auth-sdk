import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart'; // Adjust if needed

class ApiKeyTestScreen extends StatefulWidget {
  const ApiKeyTestScreen({super.key});

  @override
  State<ApiKeyTestScreen> createState() => _ApiKeyTestScreenState();
}

class _ApiKeyTestScreenState extends State<ApiKeyTestScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _verifyKeyController = TextEditingController();
  AortemMagicAuthApiKeyManagement? _apiManager;
  String _statusMessage = '';

  void _initializeSdk() {
    final inputKey = _apiKeyController.text.trim();
    try {
      final manager = AortemMagicAuthApiKeyManagement(inputKey);
      setState(() {
        _apiManager = manager;
        _statusMessage = 'SDK initialized successfully.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Initialization failed: ${e.toString()}';
      });
    }
  }

  void _updateApiKey() {
    final newKey = _apiKeyController.text.trim();
    try {
      _apiManager?.setApiKey(newKey);
      setState(() {
        _statusMessage = 'API key updated successfully.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Update failed: ${e.toString()}';
      });
    }
  }

  void _verifyApiKey() {
    final verifyKey = _verifyKeyController.text.trim();
    final result = _apiManager?.verifyApiKey(verifyKey) ?? false;
    setState(() {
      _statusMessage = result
          ? 'Verification successful: Key matches.'
          : 'Verification failed: Key does not match.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Key Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'Enter or update API key',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _initializeSdk,
                  child: const Text('Initialize SDK'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _updateApiKey,
                  child: const Text('Update Key'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _verifyKeyController,
              decoration: const InputDecoration(
                labelText: 'Verify API Key',
                hintText: 'Enter key to verify',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _verifyApiKey,
              child: const Text('Verify Key'),
            ),
            const SizedBox(height: 20),
            Text(_statusMessage, style: const TextStyle(color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
