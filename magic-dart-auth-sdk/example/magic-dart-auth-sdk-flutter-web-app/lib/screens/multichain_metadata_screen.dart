import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

class MultichainMetadataScreen extends StatefulWidget {
  const MultichainMetadataScreen({super.key});

  @override
  State<MultichainMetadataScreen> createState() =>
      _MultichainMetadataScreenState();
}

class _MultichainMetadataScreenState extends State<MultichainMetadataScreen> {
  final _identifierController = TextEditingController();
  final _walletController = TextEditingController();
  String _selectedType = 'issuer'; // Default type
  String _result = '';
  bool _isLoading = false;

  late AortemMagicMultichainMetadataService metadataService;

  @override
  void initState() {
    super.initState();
    metadataService = AortemMagicMultichainMetadataService(
      apiKey: 'your-real-or-test-api-key',
      useStub: true, // Set true to test stub response
    );
  }

  void _fetchMetadata() async {
    final identifier = _identifierController.text.trim();
    final wallet = _walletController.text.trim();

    if (identifier.isEmpty || wallet.isEmpty) {
      setState(() => _result = '❌ Both identifier and wallet are required.');
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      Map<String, dynamic> metadata;
      switch (_selectedType) {
        case 'issuer':
          metadata = await metadataService.getMetadataByIssuerAndWallet(
            identifier,
            wallet,
          );
          break;
        case 'public-address':
          metadata = await metadataService.getMetadataByPublicAddressAndWallet(
            identifier,
            wallet,
          );
          break;
        case 'token':
          metadata = await metadataService.getMetadataByTokenAndWallet(
            identifier,
            wallet,
          );
          break;
        default:
          throw ArgumentError('Unknown type: $_selectedType');
      }

      setState(() {
        _result = const JsonEncoder.withIndent('  ').convert(metadata);
      });
    } catch (e) {
      setState(() {
        _result = '❌ Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multichain Metadata Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: const [
                DropdownMenuItem(value: 'issuer', child: Text('Issuer')),
                DropdownMenuItem(
                  value: 'public-address',
                  child: Text('Public Address'),
                ),
                DropdownMenuItem(value: 'token', child: Text('Token')),
              ],
              onChanged: (value) => setState(() => _selectedType = value!),
              decoration: const InputDecoration(labelText: 'Identifier Type'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _identifierController,
              decoration: const InputDecoration(
                labelText: 'Identifier Value',
                hintText: 'Enter issuer / public address / token',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _walletController,
              decoration: const InputDecoration(
                labelText: 'Wallet Address',
                hintText: 'Enter wallet address',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchMetadata,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Fetch Metadata'),
            ),
            const SizedBox(height: 20),
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

  @override
  void dispose() {
    _identifierController.dispose();
    _walletController.dispose();
    super.dispose();
  }
}
