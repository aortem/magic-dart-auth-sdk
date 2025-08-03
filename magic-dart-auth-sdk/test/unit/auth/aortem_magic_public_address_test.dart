import 'dart:convert';

import 'package:magic_dart_auth_sdk/src/auth/aortem_magic_public_address.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('PublicAddressExtractor.getPublicAddress', () {
    // A valid Ethereum address
    const validEthAddress = '0x1234567890abcdef1234567890abcdef12345678';

    // Helper function to generate a mock DID token
    String generateDidToken(String address) {
      final header = base64Url.encode(
        utf8.encode('{"alg":"HS256","typ":"JWT"}'),
      );
      final payload = base64Url.encode(utf8.encode('{"sub":"$address"}'));
      return '$header.$payload.signature';
    }

    test('Extracts public address with strict validation - valid case', () {
      final didToken = generateDidToken(validEthAddress);
      final result = AortemMagicPublicAddressExtractor.getPublicAddress(
        didToken,
        strict: true,
      );
      expect(result, equals(validEthAddress));
    });

    test('Extracts public address with loose validation - valid case', () {
      final didToken = generateDidToken(validEthAddress);
      final result = AortemMagicPublicAddressExtractor.getPublicAddress(
        didToken,
        strict: false,
      );
      expect(result, equals(validEthAddress));
    });

    test('Throws error for empty DID Token', () {
      expect(
        () => AortemMagicPublicAddressExtractor.getPublicAddress(
          '',
          strict: true,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Throws error for invalid JWT format', () {
      expect(
        () => AortemMagicPublicAddressExtractor.getPublicAddress(
          'invalid.token',
          strict: true,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('Throws error when "sub" field is missing', () {
      final header = base64Url.encode(
        utf8.encode('{"alg":"HS256","typ":"JWT"}'),
      );
      final payload = base64Url.encode(utf8.encode('{"other_field":"value"}'));
      final invalidToken = '$header.$payload.signature';

      expect(
        () => AortemMagicPublicAddressExtractor.getPublicAddress(
          invalidToken,
          strict: true,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('Throws error for invalid Ethereum address in strict mode', () {
      final didToken = generateDidToken('0xInvalidEthAddress');
      expect(
        () => AortemMagicPublicAddressExtractor.getPublicAddress(
          didToken,
          strict: true,
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('Accepts loosely formatted Ethereum address in loose mode', () {
      final looseEthAddress = '0xabc';
      final didToken = generateDidToken(looseEthAddress);
      final result = AortemMagicPublicAddressExtractor.getPublicAddress(
        didToken,
        strict: false,
      );
      expect(result, equals(looseEthAddress));
    });

    test('Throws error for invalid Ethereum address in loose mode', () {
      final didToken = generateDidToken('InvalidAddress');
      expect(
        () => AortemMagicPublicAddressExtractor.getPublicAddress(
          didToken,
          strict: false,
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
