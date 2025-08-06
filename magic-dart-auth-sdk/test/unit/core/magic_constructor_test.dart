import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/core/magic_constructor.dart';

void main() {
  group('MagicAuth Constructor Tests', () {
    test('Initializes with valid API key', () {
      final magic = MagicAuth('valid-api-key');
      expect(magic.apiKey, equals('valid-api-key'));
    });

    test('Throws error for empty API key', () {
      expect(() => MagicAuth(''), throwsA(isA<ArgumentError>()));
    });

    test('Throws error for invalid API key format', () {
      expect(() => MagicAuth('invalid key!'), throwsA(isA<ArgumentError>()));
    });
  });

  group('MagicAuth API Key Update Tests', () {
    test('Updates API key successfully', () {
      final magic = MagicAuth('valid-api-key');
      magic.updateApiKey('new-valid-key');
      expect(magic.apiKey, equals('new-valid-key'));
    });

    test('Throws error for updating with empty API key', () {
      final magic = MagicAuth('valid-api-key');
      expect(() => magic.updateApiKey(''), throwsA(isA<ArgumentError>()));
    });

    test('Throws error for updating with invalid API key format', () {
      final magic = MagicAuth('valid-api-key');
      expect(
        () => magic.updateApiKey('invalid key!'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
