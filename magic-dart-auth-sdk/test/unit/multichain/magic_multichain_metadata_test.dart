import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/multichain/magic_multichain_metadata.dart';
import '../../support/fake_http_client.dart';

void main() {
  late MagicMultichainMetadataService metadataService;

  setUp(() {
    metadataService = MagicMultichainMetadataService(
      apiKey: 'test_api_key',
      client: FakeHttpClient(
        (_) async => http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'issuer': 'issuer_123',
              'wallet': 'wallet_abc',
              'email': 'test@example.com',
              'createdAt': '2025-02-21T12:00:00Z',
            },
          }),
          200,
        ),
      ),
    );
  });

  test('Returns metadata when retrieval is successful', () async {
    final result = await metadataService.getMetadataByIssuerAndWallet(
      'issuer_123',
      'wallet_abc',
    );

    expect(result['success'], true);
    expect(result['data']['wallet'], 'wallet_abc');
  });

  test('Throws an error when identifier or wallet is empty', () async {
    expect(
      () => metadataService.getMetadataByIssuerAndWallet('', 'wallet_abc'),
      throwsArgumentError,
    );

    expect(
      () => metadataService.getMetadataByIssuerAndWallet('issuer_123', ''),
      throwsArgumentError,
    );
  });

  test('Throws an error when API response is not 200', () async {
    metadataService = MagicMultichainMetadataService(
      apiKey: 'test_api_key',
      client: FakeHttpClient((_) async => http.Response('Unauthorized', 401)),
    );

    expect(
      () => metadataService.getMetadataByIssuerAndWallet(
        'issuer_123',
        'wallet_abc',
      ),
      throwsA(isA<Exception>()),
    );
  });

  test('Returns mock response when useStub is true', () async {
    final stubMetadataService = MagicMultichainMetadataService(
      apiKey: 'test_api_key',
      useStub: true,
    );

    final response = await stubMetadataService.getMetadataByIssuerAndWallet(
      'issuer_123',
      'wallet_abc',
    );

    expect(response['success'], true);
    expect(response['data']['wallet'], 'wallet_abc');
  });
}
