import 'dart:convert';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/auth/aortem_magic_token_decode.dart';

void main() {
  group('TokenDecoder.decode', () {
    // Sample valid payload
    const validPayload =
        '{"iss":"https://auth.magic.com","sub":"0x123456789abcdef"}';

    // Helper function to generate a mock DID token
    String generateDidToken(String payload) {
      final header = base64Url.encode(
        utf8.encode('{"alg":"HS256","typ":"JWT"}'),
      );
      final encodedPayload = base64Url.encode(utf8.encode(payload));
      return '$header.$encodedPayload.signature';
    }

    test('Decodes valid DID Token without verification', () {
      final didToken = generateDidToken(validPayload);
      final result = AortemMagicTokenDecoder.decode(didToken);
      expect(result['iss'], equals('https://auth.magic.com'));
      expect(result['sub'], equals('0x123456789abcdef'));
    });

    test('Decodes valid DID Token with verification', () {
      final didToken = generateDidToken(validPayload);
      final result = AortemMagicTokenDecoder.decode(didToken, verify: true);
      expect(result['iss'], equals('https://auth.magic.com'));
      expect(result['sub'], equals('0x123456789abcdef'));
    });

    test('Throws error for empty DID Token', () {
      expect(
        () => AortemMagicTokenDecoder.decode(''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Throws error for invalid JWT format', () {
      expect(
        () => AortemMagicTokenDecoder.decode('invalid.token'),
        throwsA(isA<FormatException>()),
      );
    });

    test('Throws error when "iss" field is missing with verification', () {
      final invalidPayload = '{"sub":"0x123456789abcdef"}';
      final didToken = generateDidToken(invalidPayload);

      expect(
        () => AortemMagicTokenDecoder.decode(didToken, verify: true),
        throwsA(isA<FormatException>()),
      );
    });

    test('Throws error when "sub" field is missing with verification', () {
      final invalidPayload = '{"iss":"https://auth.magic.com"}';
      final didToken = generateDidToken(invalidPayload);

      expect(
        () => AortemMagicTokenDecoder.decode(didToken, verify: true),
        throwsA(isA<FormatException>()),
      );
    });

    test(
      'Decodes DID Token without required fields when verification is disabled',
      () {
        final invalidPayload = '{}';
        final didToken = generateDidToken(invalidPayload);

        final result = AortemMagicTokenDecoder.decode(didToken, verify: false);
        expect(result, isEmpty);
      },
    );
  });
}
