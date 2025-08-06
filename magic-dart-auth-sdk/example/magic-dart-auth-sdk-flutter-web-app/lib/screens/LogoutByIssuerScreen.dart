import 'package:flutter/material.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'dart:convert';

class MagicLogoutByIssuer {
  final String apiKey;
  final String apiBaseUrl;
  final http.Client client;
  final bool useStub;

  MagicLogoutByIssuer({
    required this.apiKey,
    this.apiBaseUrl = "https://api.magic.com",
    http.Client? client,
    this.useStub = false,
  }) : client = client ?? http.Client();

  Future<Map<String, dynamic>> logoutByIssuer(String issuer) async {
    if (issuer.isEmpty) {
      throw ArgumentError("Issuer cannot be empty.");
    }

    if (useStub) {
      return _mockLogoutResponse(issuer);
    }

    final uri = Uri.parse("$apiBaseUrl/v1/user/logout");

    final response = await client.post(
      uri,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"issuer": issuer}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Failed to log out: ${response.statusCode} - ${response.body}",
      );
    }
  }

  Map<String, dynamic> _mockLogoutResponse(String issuer) {
    return {
      "success": true,
      "message": "User with issuer $issuer logged out successfully.",
    };
  }
}

class LogoutByIssuerScreen extends StatefulWidget {
  final String apiKey;

  const LogoutByIssuerScreen({super.key, required this.apiKey});

  @override
  State<LogoutByIssuerScreen> createState() => _LogoutByIssuerScreenState();
}

class _LogoutByIssuerScreenState extends State<LogoutByIssuerScreen> {
  final TextEditingController issuerController = TextEditingController();
  String result = '';
  bool isStub = true;
  bool isLoading = false;

  void _logout() async {
    setState(() {
      isLoading = true;
      result = '';
    });

    try {
      final sdk = MagicLogoutByIssuer(apiKey: widget.apiKey, useStub: isStub);

      final response = await sdk.logoutByIssuer(issuerController.text.trim());

      setState(() {
        result = const JsonEncoder.withIndent('  ').convert(response);
      });
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    issuerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logout by Issuer')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: issuerController,
              decoration: const InputDecoration(
                labelText: 'Issuer',
                hintText: 'e.g. did:ethr:0x1234...',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("Use Stub Mode"),
                Switch(
                  value: isStub,
                  onChanged: (val) {
                    setState(() {
                      isStub = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : _logout,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Logout"),
            ),
            const SizedBox(height: 24),
            const Text(
              "Response:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  result,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
