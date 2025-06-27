import 'dart:convert';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/auth/aortem_magic_issuer.dart';

void main() {
  group('IssuerExtractor.getIssuer', () {
    // Valid issuer
    const validIssuer = 'https://auth.magic.com';

    // Helper function to generate a mock DID token
    String generateDidToken(String issuer) {
      final header = base64Url.encode(
        utf8.encode('{"alg":"HS256","typ":"JWT"}'),
      );
      final payload = base64Url.encode(utf8.encode('{"iss":"$issuer"}'));
      return '$header.$payload.signature';
    }

    test('Extracts issuer with strict validation - valid case', () {
      final didToken = generateDidToken(validIssuer);
      final result = AortemMagicIssuerExtractor.getIssuer(
        didToken,
        strict: true,
      );
      expect(result, equals(validIssuer));
    });

    test('Extracts issuer with loose validation - valid case', () {
      final didToken = generateDidToken(validIssuer);
      final result = AortemMagicIssuerExtractor.getIssuer(
        didToken,
        strict: false,
      );
      expect(result, equals(validIssuer));
    });

    test('Throws error for empty DID Token', () {
      expect(
        () => AortemMagicIssuerExtractor.getIssuer('', strict: true),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Throws error for invalid JWT format', () {
      expect(
        () =>
            AortemMagicIssuerExtractor.getIssuer('invalid.token', strict: true),
        throwsA(isA<FormatException>()),
      );
    });

    test('Throws error when "iss" field is missing', () {
      final header = base64Url.encode(
        utf8.encode('{"alg":"HS256","typ":"JWT"}'),
      );
      final payload = base64Url.encode(utf8.encode('{"other_field":"value"}'));
      final invalidToken = '$header.$payload.signature';

      expect(
        () => AortemMagicIssuerExtractor.getIssuer(invalidToken, strict: true),
        throwsA(isA<FormatException>()),
      );
    });

    test('Throws error for invalid issuer format in strict mode', () {
      final didToken = generateDidToken('invalid_issuer');
      expect(
        () => AortemMagicIssuerExtractor.getIssuer(didToken, strict: true),
        throwsA(isA<FormatException>()),
      );
    });

    test('Accepts loosely formatted issuer in loose mode', () {
      final looseIssuer = 'auth.magic.com';
      final didToken = generateDidToken(looseIssuer);
      final result = AortemMagicIssuerExtractor.getIssuer(
        didToken,
        strict: false,
      );
      expect(result, equals(looseIssuer));
    });

    test('Throws error for invalid issuer format in loose mode', () {
      final didToken = generateDidToken('');
      expect(
        () => AortemMagicIssuerExtractor.getIssuer(didToken, strict: false),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
