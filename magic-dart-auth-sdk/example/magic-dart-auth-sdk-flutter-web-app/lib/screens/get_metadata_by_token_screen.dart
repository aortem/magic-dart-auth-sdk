import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart'; // Or adjust based on your SDK package

class GetMetadataByTokenScreen extends StatefulWidget {
  final String apiKey;
  const GetMetadataByTokenScreen({super.key, required this.apiKey});

  @override
  State<GetMetadataByTokenScreen> createState() =>
      _GetMetadataByTokenScreenState();
}

class _GetMetadataByTokenScreenState extends State<GetMetadataByTokenScreen> {
  final TextEditingController _tokenController = TextEditingController();
  String _result = '';
  bool _useStub = false;
  bool _loading = false;

  Future<void> _fetchMetadata() async {
    final token = _tokenController.text.trim();

    if (token.isEmpty) {
      setState(() => _result = '❗ Token cannot be empty.');
      return;
    }

    final client = MagicUserMetadataByToken(apiKey: widget.apiKey);

    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final metadata = _useStub
          ? await _getStubMetadata(token)
          : await client.getMetadataByToken(token);

      setState(() {
        _result = JsonEncoder.withIndent('  ').convert(metadata);
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.runtimeType}\n${e.toString()}';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<Map<String, dynamic>> _getStubMetadata(String token) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return {
      'token': token,
      'issuer': 'did:ethr:0xSTUB1234567890',
      'email': 'stub@example.com',
      'publicAddress': '0x1234567890abcdef1234567890abcdef12345678',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Metadata by Token")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: "Enter Token",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Use Stub"),
                Switch(
                  value: _useStub,
                  onChanged: (val) => setState(() => _useStub = val),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _loading ? null : _fetchMetadata,
              child: Text(_loading ? "Loading..." : "Fetch Metadata"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
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
