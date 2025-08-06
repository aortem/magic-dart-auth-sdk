import 'dart:convert';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:magic_dart_auth_sdk/src/logout/magic_logout_address.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MagicLogoutByPublicAddress logoutService;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    logoutService = MagicLogoutByPublicAddress(
      apiKey: "test_api_key",
      client: mockHttpClient,
    );

    registerFallbackValue(Uri.parse("https://api.magic.com/v1/user/logout"));
  });

  test("Returns success when logout by public address is successful", () async {
    const String testPublicAddress =
        "0x1234567890abcdef1234567890abcdef12345678";
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

    final result = await logoutService.logoutByPublicAddress(testPublicAddress);

    expect(result, expectedResponse);
  });

  test("Throws an error when public address is empty or invalid", () async {
    expect(
      () => logoutService.logoutByPublicAddress("invalid_address"),
      throwsA(isA<ArgumentError>()),
    );
  });

  test("Throws an error when API response is not 200", () async {
    const String testPublicAddress =
        "0x1234567890abcdef1234567890abcdef12345678";

    when(
      () => mockHttpClient.post(
        any(),
        headers: any(named: "headers"),
        body: any(named: "body"),
      ),
    ).thenAnswer((_) async => http.Response("Unauthorized", 401));

    expect(
      () => logoutService.logoutByPublicAddress(testPublicAddress),
      throwsA(isA<Exception>()),
    );
  });

  test("Returns mock response when useStub is true", () async {
    final stubLogoutService = MagicLogoutByPublicAddress(
      apiKey: "test_api_key",
      useStub: true,
    );

    final response = await stubLogoutService.logoutByPublicAddress(
      "0x1234567890abcdef1234567890abcdef12345678",
    );

    expect(response["success"], true);
    expect(response["message"], contains("logged out successfully"));
  });
}
