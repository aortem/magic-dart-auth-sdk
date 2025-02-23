import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:magic_dart_auth_sdk/src/core/aortem_magic_api_key_manager.dart';


void main() {
  group('API Key Manager Tests', () {
    test('Initializes with a valid API key', () {
      final apiKeyManager = AortemMagicAuthApiKeyManagement('valid-key-123');
      expect(apiKeyManager.verifyApiKey('valid-key-123'), isTrue);
    });

    test('Throws error for invalid API key', () {
      expect(() => AortemMagicAuthApiKeyManagement(''), throwsA(isA<ArgumentError>()));
    });

    test('Updates API key dynamically', () {
      final apiKeyManager = AortemMagicAuthApiKeyManagement('valid-key-123');
      apiKeyManager.setApiKey('new-key-456');
      expect(apiKeyManager.verifyApiKey('new-key-456'), isTrue);
    });

    test('Fails validation for incorrect API key', () {
      final apiKeyManager = AortemMagicAuthApiKeyManagement('valid-key-123');
      expect(apiKeyManager.verifyApiKey('wrong-key'), isFalse);
    });
  });
}
