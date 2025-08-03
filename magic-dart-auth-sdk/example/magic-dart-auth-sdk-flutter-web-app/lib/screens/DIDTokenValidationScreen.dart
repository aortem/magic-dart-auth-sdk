import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart'; // Replace with actual import path

class DIDTokenValidationScreen extends StatefulWidget {
  const DIDTokenValidationScreen({super.key});

  @override
  State<DIDTokenValidationScreen> createState() =>
      _DIDTokenValidationScreenState();
}

class _DIDTokenValidationScreenState extends State<DIDTokenValidationScreen> {
  final TextEditingController _tokenController = TextEditingController(
    text:
        'eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2V4YW1wbGUuY29tIiwic3ViIjoiMHgxMjM0NTY3ODkwYWJjZGVmIiwgImV4cCI6OTk5OTk5OTk5fQ.signature',
  );

  bool checkClaims = true;
  bool checkExpiration = false;
  bool useSeparateMethods = false;

  String? result;

  void _validateToken() {
    final token = _tokenController.text.trim();

    setState(() {
      result = null;
    });

    try {
      bool isValid;
      if (useSeparateMethods) {
        if (checkClaims || checkExpiration) {
          isValid = AortemMagicTokenValidator.fullValidate(token);
        } else {
          isValid = AortemMagicTokenValidator.basicValidate(token);
        }
      } else {
        isValid = AortemMagicTokenValidator.validate(
          token,
          checkClaims: checkClaims,
          checkExpiration: checkExpiration,
        );
      }

      setState(() {
        result = isValid ? "✅ Token is valid." : "❌ Token is invalid.";
      });
    } catch (e) {
      setState(() {
        result = "❌ Error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DID Token Validator")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Paste your DID Token below:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tokenController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'DID Token',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: checkClaims,
                  onChanged: (value) =>
                      setState(() => checkClaims = value ?? false),
                ),
                const Text("Check Claims (iss, sub)"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: checkExpiration,
                  onChanged: (value) =>
                      setState(() => checkExpiration = value ?? false),
                ),
                const Text("Check Expiration (exp)"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: useSeparateMethods,
                  onChanged: (value) =>
                      setState(() => useSeparateMethods = value ?? false),
                ),
                const Text("Use Separate Methods"),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _validateToken,
              child: const Text("Validate Token"),
            ),
            const SizedBox(height: 20),
            if (result != null)
              Text(
                result!,
                style: TextStyle(
                  fontSize: 16,
                  color: result!.startsWith("✅") ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
