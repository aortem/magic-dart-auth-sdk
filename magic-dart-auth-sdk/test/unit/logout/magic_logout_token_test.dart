import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/logout/magic_logout_token.dart';
import '../../support/fake_http_client.dart';

void main() {
  late MagicLogoutByToken logoutService;

  setUp(() {
    logoutService = MagicLogoutByToken(
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

  test('Returns success when logout by token is successful', () async {
    final result = await logoutService.logoutByToken('valid_token_123');

    expect(result['success'], true);
    expect(result['message'], 'Logged out successfully');
  });

  test('Throws an error when token is empty or invalid', () async {
    expect(() => logoutService.logoutByToken(''), throwsArgumentError);
  });

  test('Throws an error when API response is not 200', () async {
    logoutService = MagicLogoutByToken(
      apiKey: 'test_api_key',
      client: FakeHttpClient((_) async => http.Response('Unauthorized', 401)),
    );

    expect(
      () => logoutService.logoutByToken('valid_token_123'),
      throwsA(isA<Exception>()),
    );
  });

  test('Returns mock response when useStub is true', () async {
    final stubLogoutService = MagicLogoutByToken(
      apiKey: 'test_api_key',
      useStub: true,
    );

    final response = await stubLogoutService.logoutByToken('valid_token_123');

    expect(response['success'], true);
    expect(response['message'], contains('logged out successfully'));
  });
}
