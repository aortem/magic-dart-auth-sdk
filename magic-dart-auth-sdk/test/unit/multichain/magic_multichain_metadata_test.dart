import 'dart:convert';

import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:magic_dart_auth_sdk/src/multichain/aortem_magic_multichain_metadata.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MagicMultichainMetadataService metadataService;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    metadataService = MagicMultichainMetadataService(
      apiKey: "test_api_key",
      client: mockHttpClient,
    );

    registerFallbackValue(
      Uri.parse(
        "https://api.magic.com/v1/user/metadata/issuer/issuer_123?wallet=wallet_abc",
      ),
    );
  });

  test("Returns metadata when retrieval is successful", () async {
    final expectedResponse = {
      "success": true,
      "data": {
        "issuer": "issuer_123",
        "wallet": "wallet_abc",
        "email": "test@example.com",
        "createdAt": "2025-02-21T12:00:00Z",
      },
    };

    when(
      () => mockHttpClient.get(any(), headers: any(named: "headers")),
    ).thenAnswer((_) async => http.Response(jsonEncode(expectedResponse), 200));

    final result = await metadataService.getMetadataByIssuerAndWallet(
      "issuer_123",
      "wallet_abc",
    );

    expect(result, expectedResponse);
  });

  test("Throws an error when identifier or wallet is empty", () async {
    expect(
      () => metadataService.getMetadataByIssuerAndWallet("", "wallet_abc"),
      throwsA(isA<ArgumentError>()),
    );

    expect(
      () => metadataService.getMetadataByIssuerAndWallet("issuer_123", ""),
      throwsA(isA<ArgumentError>()),
    );
  });

  test("Throws an error when API response is not 200", () async {
    when(
      () => mockHttpClient.get(any(), headers: any(named: "headers")),
    ).thenAnswer((_) async => http.Response("Unauthorized", 401));

    expect(
      () => metadataService.getMetadataByIssuerAndWallet(
        "issuer_123",
        "wallet_abc",
      ),
      throwsA(isA<Exception>()),
    );
  });

  test("Returns mock response when useStub is true", () async {
    final stubMetadataService = MagicMultichainMetadataService(
      apiKey: "test_api_key",
      useStub: true,
    );

    final response = await stubMetadataService.getMetadataByIssuerAndWallet(
      "issuer_123",
      "wallet_abc",
    );

    expect(response["success"], true);
    expect(response["data"]["wallet"], "wallet_abc");
  });
}
