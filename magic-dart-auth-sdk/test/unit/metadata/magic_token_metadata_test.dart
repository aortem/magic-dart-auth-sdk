import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/metadata/magic_token_metadata.dart';
import '../../support/fake_http_client.dart';

void main() {
  late MagicUserMetadataByToken userMetadataByToken;

  setUp(() {
    userMetadataByToken = MagicUserMetadataByToken(
      apiKey: 'test_api_key',
      client: FakeHttpClient(
        (_) async => http.Response(
          jsonEncode({
            'issuer': 'did:magic:12345',
            'email': 'user@example.com',
            'public_address': '0x123456789abcdef',
            'created_at': '2024-01-01T12:00:00Z',
          }),
          200,
        ),
      ),
    );
  });

  test('Returns metadata successfully when token is valid', () async {
    final result = await userMetadataByToken.getMetadataByToken('valid_token');

    expect(result['issuer'], 'did:magic:12345');
    expect(result['email'], 'user@example.com');
  });

  test('Throws an error when token is empty', () async {
    expect(() => userMetadataByToken.getMetadataByToken(''), throwsArgumentError);
  });

  test('Throws an error when API response is not 200', () async {
    userMetadataByToken = MagicUserMetadataByToken(
      apiKey: 'test_api_key',
      client: FakeHttpClient((_) async => http.Response('Unauthorized', 401)),
    );

    expect(
      () => userMetadataByToken.getMetadataByToken('invalid_token'),
      throwsA(isA<Exception>()),
    );
  });
}
