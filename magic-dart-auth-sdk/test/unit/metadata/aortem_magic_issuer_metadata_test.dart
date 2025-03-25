import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/metadata/aortem_magic_issuer_metadata.dart';

import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

// Mock HTTP Client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late AortemMagicUserMetaDataByIssuer userMetadata;
  late MockHttpClient mockHttpClient;

  const String apiKey = "test_api_key";
  const String apiBaseUrl = "https://api.magic.com";
  const String validIssuer = "did:magic:12345";

  setUpAll(() {
    registerFallbackValue(Uri()); // FIX: Register Uri fallback
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    userMetadata = AortemMagicUserMetaDataByIssuer(
        apiKey: apiKey, apiBaseUrl: apiBaseUrl, client: mockHttpClient);
  });

  test("✅ Successfully retrieves metadata when given a valid issuer", () async {
    final mockResponse = {
      "issuer": validIssuer,
      "email": "user@example.com",
      "publicAddress": "0x123456789abcdef",
      "createdAt": 1700000000
    };

    when(() => mockHttpClient.get(any(), headers: any(named: "headers")))
        .thenAnswer(
      (_) async => http.Response(jsonEncode(mockResponse), 200),
    );

    final metadata = await userMetadata.getMetadataByIssuer(validIssuer);
    expect(metadata, isA<Map<String, dynamic>>());
    expect(metadata["issuer"], equals(validIssuer));
  });

  test("❌ Throws ArgumentError when issuer is empty", () async {
    expect(() => userMetadata.getMetadataByIssuer(""), throwsArgumentError);
  });

  test("⚠️ Handles network failure properly", () async {
    when(() => mockHttpClient.get(any(), headers: any(named: "headers")))
        .thenThrow(Exception("Network error"));

    expect(
        () => userMetadata.getMetadataByIssuer(validIssuer), throwsException);
  });
}
