import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/metadata/magic_address_metadata.dart';

import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

// Mock HTTP Client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MagicUserMetadataByPublicAddress userMetadata;
  late MockHttpClient mockHttpClient;

  const String apiKey = "test_api_key";
  const String apiBaseUrl = "https://api.magic.com";
  const String validPublicAddress = "0x123456789abcdef";

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    userMetadata = MagicUserMetadataByPublicAddress(
      apiKey: apiKey,
      apiBaseUrl: apiBaseUrl,
      client: mockHttpClient,
    );
  });

  test(
    "✅ Successfully retrieves metadata when given a valid public address",
    () async {
      final mockResponse = {
        "issuer": "did:magic:$validPublicAddress",
        "email": "user@example.com",
        "publicAddress": validPublicAddress,
        "createdAt": 1700000000,
      };

      when(
        () => mockHttpClient.get(any(), headers: any(named: "headers")),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final metadata = await userMetadata.getMetadataByPublicAddress(
        validPublicAddress,
      );
      expect(metadata, isA<Map<String, dynamic>>());
      expect(metadata["publicAddress"], equals(validPublicAddress));
    },
  );

  test("❌ Throws ArgumentError when public address is empty", () async {
    expect(
      () => userMetadata.getMetadataByPublicAddress(""),
      throwsArgumentError,
    );
  });

  test("⚠️ Handles network failure properly", () async {
    when(
      () => mockHttpClient.get(any(), headers: any(named: "headers")),
    ).thenThrow(Exception("Network error"));

    expect(
      () => userMetadata.getMetadataByPublicAddress(validPublicAddress),
      throwsException,
    );
  });

  test("🛠️ Returns stub data when useStub=true", () async {
    final metadata = await userMetadata.getMetadataByPublicAddress(
      validPublicAddress,
      useStub: true,
    );
    expect(metadata["publicAddress"], equals(validPublicAddress));
    expect(metadata.containsKey("issuer"), isTrue);
  });
}
