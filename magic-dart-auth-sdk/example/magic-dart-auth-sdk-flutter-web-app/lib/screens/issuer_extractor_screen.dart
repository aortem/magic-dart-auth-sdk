import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

class IssuerExtractorScreen extends StatefulWidget {
  const IssuerExtractorScreen({super.key});

  @override
  State<IssuerExtractorScreen> createState() => _IssuerExtractorScreenState();
}

class _IssuerExtractorScreenState extends State<IssuerExtractorScreen> {
  final TextEditingController _didTokenController = TextEditingController(
    text:
        'eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2V4YW1wbGUuY29tIn0.signature', // pre-filled dummy
  );

  String? _issuerResult;
  String? _error;
  bool _strictMode = true;

  void _extractIssuer() {
    final token = _didTokenController.text.trim();
    setState(() {
      _issuerResult = null;
      _error = null;
    });

    try {
      final issuer = MagicIssuerExtractor.getIssuer(token, strict: _strictMode);
      setState(() {
        _issuerResult = issuer;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DID Token Issuer Extractor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _didTokenController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'DID Token',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Validation Mode:'),
                const SizedBox(width: 10),
                DropdownButton<bool>(
                  value: _strictMode,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Strict')),
                    DropdownMenuItem(value: false, child: Text('Loose')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _strictMode = val!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _extractIssuer,
              child: const Text('Extract Issuer'),
            ),
            const SizedBox(height: 20),
            if (_issuerResult != null)
              SelectableText(
                '✅ Issuer: $_issuerResult',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (_error != null)
              SelectableText(
                '❌ Error: $_error',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
