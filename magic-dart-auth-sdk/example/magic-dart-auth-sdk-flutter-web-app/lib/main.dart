import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/DIDTokenValidationScreen.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/LogoutByIssuerScreen.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/LogoutByTokenScreen.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/api_key_test_screen.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/auth_header_test_screen.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/did_token_ecoder.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/did_token_public_address_screen.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/get_metadata_by_issuer_screen.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/get_metadata_by_public_address_screen.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/get_metadata_by_token_screen.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/issuer_extractor_screen.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/logout_by_public_address_screen.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/magic_constructor_screen.dart';
import 'package:magic_dart_auth_sdk_flutter_web_app/screens/multichain_metadata_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Dart Auth Sample',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      // routes: {'/': (context) => const MagicHomePage()},
      home: const MagicHomePage(),
    );
  }
}

class MagicHomePage extends StatelessWidget {
  const MagicHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Magic Dart Auth Web Sample")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FeatureButton(
                title: "Constructor Implementation",
                description: "configure and authenticate API interactions",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MagicConstructorScreen(),
                    ),
                  );
                },
              ),
              FeatureButton(
                title: "ApiKeyTest",
                description:
                    "API Key Validation, Secure Storage, and Dynamic Updates",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ApiKeyTestScreen()),
                  );
                },
              ),
              FeatureButton(
                title: "DID Token → Public Address Extraction",
                description:
                    "showcasing both strict and loose validation modes",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DidTokenPublicAddressScreen(),
                    ),
                  );
                },
              ),
              FeatureButton(
                title: "MagicIssuerExtractor",
                description:
                    "Issuer extraction from a DID token with both strict and loose validation modes",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const IssuerExtractorScreen(),
                    ),
                  );
                },
              ),
              FeatureButton(
                title: "MagicTokenDecoder",
                description:
                    "MagicTokenDecoder.decode() method with optional verification toggle",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DidTokenDecoderScreen(),
                    ),
                  );
                },
              ),
              FeatureButton(
                title: "MagicTokenValidator",
                description:
                    "validation approaches (optional parameter method and separate methods) for a DID token",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DIDTokenValidationScreen(),
                    ),
                  );
                },
              ),
              FeatureButton(
                title: "MagicUserMetaDataByIssuer",
                description:
                    "getMetadataByIssuer with toggleable Live vs Stub mode, issuer input, and result preview",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GetMetadataByIssuerScreen(
                        apiKey: 'sk_live_8B21F43F636C437F',
                      ),
                    ),
                  );
                },
              ),
              FeatureButton(
                title: "MagicUserMetadataByPublicAddress",
                description:
                    "getMetadataByPublicAddress SDK feature, including stub support and error handling.",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GetMetadataByPublicAddressScreen(
                        apiKey: 'sk_live_8B21F43F636C437F',
                      ),
                    ),
                  );
                },
              ),
              FeatureButton(
                title: "MagicUserMetadataByToken",
                description:
                    "getMetadataByToken SDK feature, with stub & HTTP support.",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GetMetadataByTokenScreen(
                        apiKey: 'sk_live_8B21F43F636C437F',
                      ),
                    ),
                  );
                },
              ),
              FeatureButton(
                title: "Logout by Issuer",
                description: "Calls logoutByIssuer (live or stub).",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LogoutByIssuerScreen(
                        apiKey: 'sk_live_8B21F43F636C437F',
                      ),
                    ),
                  );
                },
              ),
              FeatureButton(
                title: "Logout by Public Address",
                description:
                    "terminating a user session based on the provided public address",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LogoutByPublicAddressScreen(),
                    ),
                  );
                },
              ),
              FeatureButton(
                title: "MagicLogoutByToken",
                description:
                    "logoutByToken SDK feature with stub and live modes.",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LogoutByTokenScreen(),
                    ),
                  );
                },
              ),
              FeatureButton(
                title: "MultichainMetadata",
                description:
                    "Implement Multichain Methods with Flexible Options",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MultichainMetadataScreen(),
                    ),
                  );
                },
              ),
              FeatureButton(
                title: "MagicAuthHeaderParse",
                description:
                    "parsing an HTTP Authorization header and extracting the token from it",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AuthHeaderTestScreen(),
                    ),
                  );
                },
              ),
              // Add more FeatureButton widgets as needed for other features
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const FeatureButton({
    super.key,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: onPressed,
      ),
    );
  }
}
