import 'dart:convert';

import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart'; // Replace with actual import path
import 'package:flutter/material.dart';
import 'package:magic_sdk/magic_sdk.dart';

class GetMetadataByIssuerScreen extends StatefulWidget {
  final String apiKey;
  const GetMetadataByIssuerScreen({super.key, required this.apiKey});

  @override
  State<GetMetadataByIssuerScreen> createState() =>
      _GetMetadataByIssuerScreenState();
}

class _GetMetadataByIssuerScreenState extends State<GetMetadataByIssuerScreen> {
  final TextEditingController _issuerController = TextEditingController();
  String _result = '';
  bool _useStub = false;
  bool _loading = false;

  Future<void> _fetchMetadata() async {
    final issuer = _issuerController.text.trim();
    if (!issuer.startsWith('https://')) {
      throw ArgumentError("Issuer must start with https://");
    }

    final client = MagicUserMetaDataByIssuer(apiKey: widget.apiKey);

    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final metadata = await client.getMetadataByIssuer(issuer);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Metadata by Issuer")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _issuerController,
              decoration: const InputDecoration(
                labelText: "Enter Issuer",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Use Stub"),
                Switch(
                  value: _useStub,
                  onChanged: (val) {
                    setState(() => _useStub = val);
                  },
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
