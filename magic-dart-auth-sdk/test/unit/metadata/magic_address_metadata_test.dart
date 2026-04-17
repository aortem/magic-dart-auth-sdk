import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/metadata/magic_address_metadata.dart';
import '../../support/fake_http_client.dart';

void main() {
  late MagicUserMetadataByPublicAddress userMetadata;

  const apiKey = 'test_api_key';
  const apiBaseUrl = 'https://api.magic.com';
  const validPublicAddress = '0x123456789abcdef';

  setUp(() {
    userMetadata = MagicUserMetadataByPublicAddress(
      apiKey: apiKey,
      apiBaseUrl: apiBaseUrl,
      client: FakeHttpClient(
        (_) async => http.Response(
          jsonEncode({
            'issuer': 'did:magic:$validPublicAddress',
            'email': 'user@example.com',
            'publicAddress': validPublicAddress,
            'createdAt': 1700000000,
          }),
          200,
        ),
      ),
    );
  });

  test('Successfully retrieves metadata for a valid public address', () async {
    final metadata = await userMetadata.getMetadataByPublicAddress(
      validPublicAddress,
    );

    expect(metadata, isA<Map<String, dynamic>>());
    expect(metadata['publicAddress'], validPublicAddress);
  });

  test('Throws ArgumentError when public address is empty', () async {
    expect(
      () => userMetadata.getMetadataByPublicAddress(''),
      throwsArgumentError,
    );
  });

  test('Handles network failure properly', () async {
    userMetadata = MagicUserMetadataByPublicAddress(
      apiKey: apiKey,
      apiBaseUrl: apiBaseUrl,
      client: FakeHttpClient((_) async => throw Exception('Network error')),
    );

    expect(
      () => userMetadata.getMetadataByPublicAddress(validPublicAddress),
      throwsException,
    );
  });

  test('Returns stub data when useStub is true', () async {
    final metadata = await userMetadata.getMetadataByPublicAddress(
      validPublicAddress,
      useStub: true,
    );
    expect(metadata['publicAddress'], validPublicAddress);
    expect(metadata.containsKey('issuer'), isTrue);
  });
}
