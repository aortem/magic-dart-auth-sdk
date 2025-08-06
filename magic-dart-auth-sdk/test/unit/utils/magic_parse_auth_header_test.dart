import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/utils/aortem_magic_parse_auth_header.dart';

void main() {
  group('MagicUtils.parseAuthorizationHeader', () {
    test('Extracts token from a valid Authorization header', () {
      const header = 'Bearer abc123tokenXYZ';
      expect(
        MagicAuthHeaderParse.parseAuthorizationHeader(header),
        equals('abc123tokenXYZ'),
      );
    });

    test('Handles extra spaces in Authorization header', () {
      const header = '   Bearer    abc123tokenXYZ   ';
      expect(
        MagicAuthHeaderParse.parseAuthorizationHeader(header),
        equals('abc123tokenXYZ'),
      );
    });

    test('Throws ArgumentError for empty header', () {
      expect(
        () => MagicAuthHeaderParse.parseAuthorizationHeader(''),
        throwsArgumentError,
      );
    });

    test('Throws ArgumentError for missing Bearer prefix', () {
      const header = 'Token abc123tokenXYZ';
      expect(
        () => MagicAuthHeaderParse.parseAuthorizationHeader(header),
        throwsArgumentError,
      );
    });

    test('Throws ArgumentError for malformed header', () {
      const header = 'Bearer123tokenXYZ';
      expect(
        () => MagicAuthHeaderParse.parseAuthorizationHeader(header),
        throwsArgumentError,
      );
    });

    test('Throws ArgumentError for multiple spaces but no valid token', () {
      const header = 'Bearer   ';
      expect(
        () => MagicAuthHeaderParse.parseAuthorizationHeader(header),
        throwsArgumentError,
      );
    });
  });
}
