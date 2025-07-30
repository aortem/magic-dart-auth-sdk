import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

class GetMetadataByPublicAddressScreen extends StatefulWidget {
  final String apiKey;
  const GetMetadataByPublicAddressScreen({super.key, required this.apiKey});

  @override
  State<GetMetadataByPublicAddressScreen> createState() =>
      _GetMetadataByPublicAddressScreenState();
}

class _GetMetadataByPublicAddressScreenState
    extends State<GetMetadataByPublicAddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  String _result = '';
  bool _useStub = false;
  bool _loading = false;

  Future<void> _fetchMetadata() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      setState(() => _result = 'Error: Public address cannot be empty.');
      return;
    }

    final client =
        AortemMagicUserMetadataByPublicAddress(apiKey: widget.apiKey);

    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final metadata = await client.getMetadataByPublicAddress(
        address,
        useStub: _useStub,
      );

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
      appBar: AppBar(title: const Text("Get Metadata by Public Address")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: "Enter Public Address",
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
