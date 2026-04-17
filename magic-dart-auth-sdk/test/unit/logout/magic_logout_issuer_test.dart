import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/logout/magic_logout_issuer.dart';
import '../../support/fake_http_client.dart';

void main() {
  late MagicLogoutByIssuer logoutService;

  setUp(() {
    logoutService = MagicLogoutByIssuer(
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

  test('Returns success when logout is successful', () async {
    const testIssuer = 'did:magic:12345';

    final result = await logoutService.logoutByIssuer(testIssuer);

    expect(result['success'], true);
    expect(result['message'], 'Logged out successfully');
  });

  test('Throws an error when issuer is empty', () async {
    expect(() => logoutService.logoutByIssuer(''), throwsArgumentError);
  });

  test('Throws an error when API response is not 200', () async {
    logoutService = MagicLogoutByIssuer(
      apiKey: 'test_api_key',
      client: FakeHttpClient((_) async => http.Response('Unauthorized', 401)),
    );

    expect(
      () => logoutService.logoutByIssuer('did:magic:invalid'),
      throwsA(isA<Exception>()),
    );
  });

  test('Returns mock response when useStub is true', () async {
    final stubLogoutService = MagicLogoutByIssuer(
      apiKey: 'test_api_key',
      useStub: true,
    );

    final response = await stubLogoutService.logoutByIssuer('did:magic:12345');

    expect(response['success'], true);
    expect(response['message'], contains('logged out successfully'));
  });
}
