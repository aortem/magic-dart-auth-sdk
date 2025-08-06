import 'dart:convert';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:magic_dart_auth_sdk/src/logout/magic_logout_token.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MagicLogoutByToken logoutService;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    logoutService = MagicLogoutByToken(
      apiKey: "test_api_key",
      client: mockHttpClient,
    );

    registerFallbackValue(Uri.parse("https://api.magic.com/v1/user/logout"));
  });

  test("Returns success when logout by token is successful", () async {
    const String testToken = "valid_token_123";
    final expectedResponse = {
      "success": true,
      "message": "Logged out successfully",
    };

    when(
      () => mockHttpClient.post(
        any(),
        headers: any(named: "headers"),
        body: any(named: "body"),
      ),
    ).thenAnswer((_) async => http.Response(jsonEncode(expectedResponse), 200));

    final result = await logoutService.logoutByToken(testToken);

    expect(result, expectedResponse);
  });

  test("Throws an error when token is empty or invalid", () async {
    expect(
      () => logoutService.logoutByToken(""),
      throwsA(isA<ArgumentError>()),
    );
  });

  test("Throws an error when API response is not 200", () async {
    const String testToken = "valid_token_123";

    when(
      () => mockHttpClient.post(
        any(),
        headers: any(named: "headers"),
        body: any(named: "body"),
      ),
    ).thenAnswer((_) async => http.Response("Unauthorized", 401));

    expect(
      () => logoutService.logoutByToken(testToken),
      throwsA(isA<Exception>()),
    );
  });

  test("Returns mock response when useStub is true", () async {
    final stubLogoutService = MagicLogoutByToken(
      apiKey: "test_api_key",
      useStub: true,
    );

    final response = await stubLogoutService.logoutByToken("valid_token_123");

    expect(response["success"], true);
    expect(response["message"], contains("logged out successfully"));
  });
}
