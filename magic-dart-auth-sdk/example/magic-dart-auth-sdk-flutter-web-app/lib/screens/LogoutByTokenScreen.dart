import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

class LogoutByTokenScreen extends StatefulWidget {
  const LogoutByTokenScreen({super.key});

  @override
  State<LogoutByTokenScreen> createState() => _LogoutByTokenScreenState();
}

class _LogoutByTokenScreenState extends State<LogoutByTokenScreen> {
  final TextEditingController _tokenController = TextEditingController();
  String _result = '';
  bool _loading = false;
  bool _useStub = false;

  late final AortemMagicLogoutByToken _logoutHandler;

  @override
  void initState() {
    super.initState();
    _logoutHandler = AortemMagicLogoutByToken(
      apiKey: 'sk_live_8B21F43F636C437F', // 🔒 Replace with your key securely
      apiBaseUrl: 'https://api.magic.link', // 🔁 Can be proxy/backend endpoint
      useStub: _useStub,
    );
  }

  Future<void> _logout() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      setState(() => _result = '❌ Error: Token cannot be empty.');
      return;
    }

    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final res = await _logoutHandler.logoutByToken(token);
      setState(() {
        _result = JsonEncoder.withIndent('  ').convert(res);
      });
    } catch (e) {
      setState(() {
        _result = '❌ Logout failed: $e';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Logout by Token")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: "Enter User Token",
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
                    setState(() {
                      _useStub = val;
                      _logoutHandler = AortemMagicLogoutByToken(
                        apiKey: 'sk_live_8B21F43F636C437F',
                        apiBaseUrl: 'https://api.magic.link',
                        useStub: _useStub,
                      );
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _loading ? null : _logout,
              child: Text(_loading ? "Logging out..." : "Logout"),
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
}
