import 'dart:convert';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/auth/aortem_magic_token_validation.dart';

void main() {
  group('TokenValidator.validate', () {
    // Sample valid payload
    final validPayload =
        '{"iss":"https://auth.magic.com","sub":"0x123456789abcdef","exp":${(DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600}}';

    // Sample expired token payload
    final expiredPayload =
        '{"iss":"https://auth.magic.com","sub":"0x123456789abcdef","exp":${(DateTime.now().millisecondsSinceEpoch ~/ 1000) - 3600}}';

    // Helper function to generate a mock DID token
    String generateDidToken(String payload) {
      final header = base64Url.encode(
        utf8.encode('{"alg":"HS256","typ":"JWT"}'),
      );
      final encodedPayload = base64Url.encode(utf8.encode(payload));
      return '$header.$encodedPayload.signature';
    }

    test(
      'Validates a properly formatted DID Token without additional checks',
      () {
        final didToken = generateDidToken(validPayload);
        expect(MagicTokenValidator.validate(didToken), isTrue);
      },
    );

    test('Validates a DID Token with required claims', () {
      final didToken = generateDidToken(validPayload);
      expect(MagicTokenValidator.validate(didToken, checkClaims: true), isTrue);
    });

    test('Throws error if "iss" field is missing', () {
      final invalidPayload = '{"sub":"0x123456789abcdef"}';
      final didToken = generateDidToken(invalidPayload);

      expect(
        () => MagicTokenValidator.validate(didToken, checkClaims: true),
        throwsA(isA<FormatException>()),
      );
    });

    test('Throws error if "sub" field is missing', () {
      final invalidPayload = '{"iss":"https://auth.magic.com"}';
      final didToken = generateDidToken(invalidPayload);

      expect(
        () => MagicTokenValidator.validate(didToken, checkClaims: true),
        throwsA(isA<FormatException>()),
      );
    });

    test('Throws error if token is expired', () {
      final didToken = generateDidToken(expiredPayload);

      expect(
        () => MagicTokenValidator.validate(didToken, checkExpiration: true),
        throwsA(isA<FormatException>()),
      );
    });

    test('Passes validation if token is not expired', () {
      final didToken = generateDidToken(validPayload);
      expect(
        MagicTokenValidator.validate(didToken, checkExpiration: true),
        isTrue,
      );
    });

    test('Basic validation checks only format', () {
      final didToken = generateDidToken(validPayload);
      expect(MagicTokenValidator.basicValidate(didToken), isTrue);
    });

    test('Full validation checks format, claims, and expiration', () {
      final didToken = generateDidToken(validPayload);
      expect(MagicTokenValidator.fullValidate(didToken), isTrue);
    });
  });
}
