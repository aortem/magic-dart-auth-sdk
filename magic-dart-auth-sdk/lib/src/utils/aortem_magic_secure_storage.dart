import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart';

/// A utility class for securely handling API keys using SHA-256 hashing.
class AortemMagicSecureStorage {
  /// Hashes the given [apiKey] using the SHA-256 algorithm for secure storage.
  ///
  /// This method converts the API key into a SHA-256 hash, which ensures that
  /// the original key is not stored in plain text.
  ///
  /// Example:
  /// ```dart
  /// String hashedKey = SecureStorage.hashApiKey("my-secret-api-key");
  /// print(hashedKey); // Outputs hashed representation of the key
  /// ```
  ///
  /// Returns a hashed string representation of the API key.
  static String hashApiKey(String apiKey) {
    final bytes = utf8.encode(apiKey);
    final digest = sha256.convert(bytes);
    return digest.toString(); // Returns hashed API key
  }

  /// Validates if the given [inputKey] matches the [storedHash].
  ///
  /// This method hashes the input key and compares it with the stored hash
  /// to verify if they are the same.
  ///
  /// Example:
  /// ```dart
  /// bool isValid = SecureStorage.validateApiKey("my-secret-api-key", storedHash);
  /// print(isValid); // Outputs true if the key matches the stored hash
  /// ```
  ///
  /// Returns `true` if the input key matches the stored hash, otherwise `false`.
  static bool validateApiKey(String inputKey, String storedHash) {
    return hashApiKey(inputKey) == storedHash;
  }
}
