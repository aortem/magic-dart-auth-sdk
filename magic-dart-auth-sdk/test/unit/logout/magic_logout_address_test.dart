import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/logout/magic_logout_address.dart';
import '../../support/fake_http_client.dart';

void main() {
  late MagicLogoutByPublicAddress logoutService;

  setUp(() {
    logoutService = MagicLogoutByPublicAddress(
      apiKey: 'test_api_key',
      client: FakeHttpClient(
        (_) async => http.Response(
          jsonEncode({
            'success': true,
            'message': 'Logged out successfully',
          }),
          200,
        ),
      ),
    );
  });

  test('Returns success when logout by public address is successful', () async {
    const testPublicAddress = '0x1234567890abcdef1234567890abcdef12345678';

    final result = await logoutService.logoutByPublicAddress(testPublicAddress);

    expect(result['success'], true);
    expect(result['message'], 'Logged out successfully');
  });

  test('Throws an error when public address is empty or invalid', () async {
    expect(
      () => logoutService.logoutByPublicAddress('invalid_address'),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('Throws an error when API response is not 200', () async {
    const testPublicAddress = '0x1234567890abcdef1234567890abcdef12345678';
    logoutService = MagicLogoutByPublicAddress(
      apiKey: 'test_api_key',
      client: FakeHttpClient((_) async => http.Response('Unauthorized', 401)),
    );

    expect(
      () => logoutService.logoutByPublicAddress(testPublicAddress),
      throwsA(isA<Exception>()),
    );
  });

  test('Returns mock response when useStub is true', () async {
    final stubLogoutService = MagicLogoutByPublicAddress(
      apiKey: 'test_api_key',
      useStub: true,
    );

    final response = await stubLogoutService.logoutByPublicAddress(
      '0x1234567890abcdef1234567890abcdef12345678',
    );

    expect(response['success'], true);
    expect(response['message'], contains('logged out successfully'));
  });
}
