import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

class LogoutByPublicAddressScreen extends StatefulWidget {
  const LogoutByPublicAddressScreen({Key? key}) : super(key: key);

  @override
  State<LogoutByPublicAddressScreen> createState() =>
      _LogoutByPublicAddressScreenState();
}

class _LogoutByPublicAddressScreenState
    extends State<LogoutByPublicAddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  String _result = '';
  bool _loading = false;

  late final MagicLogoutByPublicAddress _magicLogout;

  @override
  void initState() {
    super.initState();
    _magicLogout = MagicLogoutByPublicAddress(
      apiKey: 'sk_live_8B21F43F636C437F', // Replace with your valid key
      apiBaseUrl: 'https://api.magic.link', // or your proxy
      useStub: false, // Set to true to test stub behavior
    );
  }

  Future<void> _logout() async {
    final address = _addressController.text.trim();

    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final res = await _magicLogout.logoutByPublicAddress(address);
      setState(() {
        _result = '✅ Logout successful:\n${res.toString()}';
      });
    } catch (e) {
      setState(() {
        _result = '❌ Logout failed: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Logout by Public Address")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Enter Ethereum Public Address"),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: "Public Address",
                hintText: "0x...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _logout,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Logout"),
            ),
            const SizedBox(height: 24),
            SelectableText(_result),
          ],
        ),
      ),
    );
  }
}
