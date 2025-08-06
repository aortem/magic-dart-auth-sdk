import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

class DidTokenPublicAddressScreen extends StatefulWidget {
  const DidTokenPublicAddressScreen({super.key});

  @override
  State<DidTokenPublicAddressScreen> createState() =>
      _DidTokenPublicAddressScreenState();
}

class _DidTokenPublicAddressScreenState
    extends State<DidTokenPublicAddressScreen> {
  final TextEditingController _didTokenController = TextEditingController();
  bool _isStrict = true;
  String? _publicAddress;
  String? _error;

  void _extractAddress() {
    setState(() {
      _publicAddress = null;
      _error = null;
    });

    try {
      final address = MagicPublicAddressExtractor.getPublicAddress(
        _didTokenController.text.trim(),
        strict: _isStrict,
      );
      setState(() {
        _publicAddress = address;
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
      appBar: AppBar(title: const Text('DID Token → Public Address')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _didTokenController,
              decoration: const InputDecoration(
                labelText: 'DID Token (JWT format)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Validation Mode:"),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _isStrict,
                      onChanged: (val) => setState(() => _isStrict = val!),
                    ),
                    const Text("Strict"),
                    Radio<bool>(
                      value: false,
                      groupValue: _isStrict,
                      onChanged: (val) => setState(() => _isStrict = val!),
                    ),
                    const Text("Loose"),
                  ],
                ),
              ],
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.key),
              label: const Text('Extract Public Address'),
              onPressed: _extractAddress,
            ),
            const SizedBox(height: 24),
            if (_publicAddress != null) ...[
              const Text(
                '✅ Extracted Public Address:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              SelectableText(
                _publicAddress!,
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              const Text(
                '❌ Error:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 6),
              SelectableText(
                _error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
