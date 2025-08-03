import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

class DidTokenDecoderScreen extends StatefulWidget {
  const DidTokenDecoderScreen({super.key});

  @override
  State<DidTokenDecoderScreen> createState() => _DidTokenDecoderScreenState();
}

class _DidTokenDecoderScreenState extends State<DidTokenDecoderScreen> {
  final TextEditingController _didTokenController = TextEditingController();
  bool _verify = false;
  Map<String, dynamic>? _decodedPayload;
  String? _error;

  void _decodeToken() {
    setState(() {
      _decodedPayload = null;
      _error = null;
    });

    try {
      final payload = AortemMagicTokenDecoder.decode(
        _didTokenController.text.trim(),
        verify: _verify,
      );
      setState(() {
        _decodedPayload = payload;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _didTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DID Token Decoder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _didTokenController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Enter DID Token (JWT)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Verify required fields'),
                Switch(
                  value: _verify,
                  onChanged: (val) => setState(() => _verify = val),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _decodeToken,
              child: const Text('Decode Token'),
            ),
            const SizedBox(height: 20),
            if (_decodedPayload != null) ...[
              const Text(
                '✅ Decoded Payload:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SelectableText(_decodedPayload.toString()),
            ],
            if (_error != null) ...[
              const Text(
                '❌ Error:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SelectableText(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              '🧪 Dummy Token for Testing (with iss & sub):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SelectableText(
              'eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2V4YW1wbGUuY29tIiwic3ViIjoiMHgxMjM0NTY3ODkwYWJjZGVmIn0.signature',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
