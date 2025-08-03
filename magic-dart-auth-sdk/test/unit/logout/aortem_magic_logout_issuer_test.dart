import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/logout/aortem_magic_logout_issuer.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late AortemMagicLogoutByIssuer logoutService;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    logoutService = AortemMagicLogoutByIssuer(
      apiKey: "test_api_key",
      client: mockHttpClient,
    );

    registerFallbackValue(Uri.parse("https://api.magic.com/v1/user/logout"));
  });

  test("Returns success when logout is successful", () async {
    const String testIssuer = "did:magic:12345";
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

    final result = await logoutService.logoutByIssuer(testIssuer);

    expect(result, expectedResponse);
  });

  test("Throws an error when issuer is empty", () async {
    expect(
      () => logoutService.logoutByIssuer(""),
      throwsA(isA<ArgumentError>()),
    );
  });

  test("Throws an error when API response is not 200", () async {
    const String testIssuer = "did:magic:invalid";

    when(
      () => mockHttpClient.post(
        any(),
        headers: any(named: "headers"),
        body: any(named: "body"),
      ),
    ).thenAnswer((_) async => http.Response("Unauthorized", 401));

    expect(
      () => logoutService.logoutByIssuer(testIssuer),
      throwsA(isA<Exception>()),
    );
  });

  test("Returns mock response when useStub is true", () async {
    final stubLogoutService = AortemMagicLogoutByIssuer(
      apiKey: "test_api_key",
      useStub: true,
    );

    final response = await stubLogoutService.logoutByIssuer("did:magic:12345");

    expect(response["success"], true);
    expect(response["message"], contains("logged out successfully"));
  });
}
