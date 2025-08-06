/// MagicAuth
///
/// A class responsible for handling API key authentication securely within the Aortem Magic authentication system.
/// It ensures proper validation and allows secure storage and retrieval of API keys.
///
/// ## Features:
/// - Validates API keys against a defined pattern.
/// - Stores API keys securely and allows updates.
/// - Provides methods for retrieving and modifying API keys dynamically.
///
/// ## Usage Example:
/// ```dart
/// var auth = MagicAuth('your-api-key');
/// print(auth.apiKey); // Outputs the stored API key
/// auth.updateApiKey('new-api-key');
/// ```
class MagicAuth {
  /// Stores the API key securely.
  late String _apiKey; // Use 'late' to ensure it gets initialized

  /// Regular expression pattern for validating API keys.
  static final RegExp _apiKeyPattern = RegExp(r'^[a-zA-Z0-9._-]+$');

  /// Constructor with API key validation.
  /// - Throws an [ArgumentError] if the API key is invalid.
  MagicAuth(String apiKey) {
    if (apiKey.isEmpty || !_validateApiKey(apiKey)) {
      throw ArgumentError('Invalid API key.');
    }
    _apiKey = apiKey;
  }

  /// Validates the API key format.
  /// - Returns `true` if the key follows the correct format, otherwise `false`.
  bool _validateApiKey(String key) {
    return _apiKeyPattern.hasMatch(key);
  }

  /// Retrieves the stored API key securely.
  String get apiKey => _apiKey;

  /// Dynamically updates the API key with validation.
  /// - Throws an [ArgumentError] if the new key is invalid.
  void updateApiKey(String newKey) {
    if (newKey.isEmpty || !_validateApiKey(newKey)) {
      throw ArgumentError('Invalid API key.');
    }
    _apiKey = newKey;
  }
}
