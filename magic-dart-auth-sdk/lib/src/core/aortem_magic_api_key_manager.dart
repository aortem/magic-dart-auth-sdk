import '../utils/aortem_magic_secure_storage.dart';

/// AortemMagicAuthApiKeyManagement
///
/// A class responsible for managing API keys securely within the Aortem Magic authentication system.
/// It provides validation, hashing, and verification functionality.
///
/// ## Features:
/// - Stores API keys in a hashed format for security.
/// - Validates API key format before storing.
/// - Provides a method to verify if an input key matches the stored hash.
///
/// ## Usage Example:
/// ```dart
/// var apiKeyManager = AortemMagicAuthApiKeyManagement('your-api-key');
/// bool isValid = apiKeyManager.verifyApiKey('your-api-key');
/// print(isValid); // Outputs: true if valid
/// ```

class AortemMagicAuthApiKeyManagement {
  /// Stores the hashed version of the API key.
  late String _hashedApiKey;

  /// Constructor to initialize with a validated API key.
  /// - [apiKey]: The API key to be stored securely.
  AortemMagicAuthApiKeyManagement(String apiKey) {
    setApiKey(apiKey);
  }

  /// Validates and sets a new API key in a hashed format.
  /// - Throws an [ArgumentError] if the API key is invalid.
  void setApiKey(String apiKey) {
    if (apiKey.isEmpty || !_validateApiKey(apiKey)) {
      throw ArgumentError('Invalid API key.');
    }
    _hashedApiKey = AortemMagicSecureStorage.hashApiKey(apiKey);
  }

  /// Verifies if the provided API key matches the stored hashed API key.
  /// - Returns `true` if the input key is valid, otherwise `false`.
  bool verifyApiKey(String inputKey) {
    return AortemMagicSecureStorage.validateApiKey(inputKey, _hashedApiKey);
  }

  /// Ensures the API key follows a strict format.
  /// - Returns `true` if the key follows the correct format, otherwise `false`.
  bool _validateApiKey(String key) {
    return RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(key);
  }
}
