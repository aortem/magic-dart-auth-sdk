import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/metadata/magic_issuer_metadata.dart';
import '../../support/fake_http_client.dart';

void main() {
  late MagicUserMetaDataByIssuer userMetadata;

  const apiKey = 'test_api_key';
  const apiBaseUrl = 'https://api.magic.com';
  const validIssuer = 'did:magic:12345';

  setUp(() {
    userMetadata = MagicUserMetaDataByIssuer(
      apiKey: apiKey,
      apiBaseUrl: apiBaseUrl,
      client: FakeHttpClient(
        (_) async => http.Response(
          jsonEncode({
            'issuer': validIssuer,
            'email': 'user@example.com',
            'publicAddress': '0x123456789abcdef',
            'createdAt': 1700000000,
          }),
          200,
        ),
      ),
    );
  });

  test('Successfully retrieves metadata for a valid issuer', () async {
    final metadata = await userMetadata.getMetadataByIssuer(validIssuer);

    expect(metadata, isA<Map<String, dynamic>>());
    expect(metadata['issuer'], validIssuer);
  });

  test('Throws ArgumentError when issuer is empty', () async {
    expect(() => userMetadata.getMetadataByIssuer(''), throwsArgumentError);
  });

  test('Handles network failure properly', () async {
    userMetadata = MagicUserMetaDataByIssuer(
      apiKey: apiKey,
      apiBaseUrl: apiBaseUrl,
      client: FakeHttpClient((_) async => throw Exception('Network error')),
    );

    expect(() => userMetadata.getMetadataByIssuer(validIssuer), throwsException);
  });
}
