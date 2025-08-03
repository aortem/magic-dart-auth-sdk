import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/metadata/aortem_magic_token_metadata.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late AortemMagicUserMetadataByToken userMetadataByToken;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    userMetadataByToken = AortemMagicUserMetadataByToken(
      apiKey: "test_api_key",
      client: mockHttpClient,
    );

    // Register fallback value for Uri
    registerFallbackValue(Uri.parse("https://api.magic.com/v1/user/metadata"));
  });

  test("Returns metadata successfully when token is valid", () async {
    const String testToken = "valid_token";
    final expectedResponse = {
      "issuer": "did:magic:12345",
      "email": "user@example.com",
      "public_address": "0x123456789abcdef",
      "created_at": "2024-01-01T12:00:00Z",
    };

    when(
      () => mockHttpClient.get(any(), headers: any(named: "headers")),
    ).thenAnswer((_) async => http.Response(jsonEncode(expectedResponse), 200));

    final result = await userMetadataByToken.getMetadataByToken(testToken);

    expect(result, expectedResponse);
  });

  test("Throws an error when token is empty", () async {
    expect(
      () => userMetadataByToken.getMetadataByToken(""),
      throwsA(isA<ArgumentError>()),
    );
  });

  test("Throws an error when API response is not 200", () async {
    const String testToken = "invalid_token";

    when(
      () => mockHttpClient.get(any(), headers: any(named: "headers")),
    ).thenAnswer((_) async => http.Response("Unauthorized", 401));

    expect(
      () => userMetadataByToken.getMetadataByToken(testToken),
      throwsA(isA<Exception>()),
    );
  });
}
