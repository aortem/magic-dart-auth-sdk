import 'dart:convert';

/// MagicTokenValidator
///
/// A utility class for validating Decentralized Identifier (DID) Tokens (JWT format).
/// Provides various validation options, including format checking, claim verification, and expiration handling.
///
/// ## Features:
/// - Validates JWT format (must have three parts: header, payload, signature).
/// - Decodes and verifies required claims (`iss`, `sub`).
/// - Checks for token expiration (`exp` claim) if required.
/// - Provides basic and full validation methods.
///
/// ## Usage Example:
/// ```dart
/// String didToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIweDEyMzQ1Njc4OWFiY2RlZjAxMjM0NTY3ODlhYmNkZWYwIn0.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
/// bool isValid = MagicTokenValidator.validate(didToken, checkClaims: true, checkExpiration: true);
/// print(isValid); // Outputs: true if valid
/// ```

class MagicTokenValidator {
  /// Validates a DID Token (JWT format).
  /// - [didToken]: The DID Token.
  /// - [checkClaims]: If `true`, verifies required claims (`iss`, `sub`).
  /// - [checkExpiration]: If `true`, verifies `exp` claim (if present).
  ///
  /// Throws an error if validation fails.
  static bool validate(
    String didToken, {
    bool checkClaims = false,
    bool checkExpiration = false,
  }) {
    if (didToken.isEmpty) {
      throw ArgumentError('DID Token cannot be empty.');
    }

    try {
      // Validate JWT format
      _validateJwtFormat(didToken);

      // Decode payload
      Map<String, dynamic> payload = _decodeJwtPayload(didToken);

      // Check required claims
      if (checkClaims) {
        _verifyRequiredClaims(payload);
      }

      // Check expiration
      if (checkExpiration) {
        _verifyExpiration(payload);
      }

      return true; // Token is valid
    } catch (e) {
      throw FormatException('Invalid DID Token: ${e.toString()}');
    }
  }

  /// Validates JWT format (must have 3 parts: header.payload.signature).
  static void _validateJwtFormat(String token) {
    List<String> parts = token.split('.');
    if (parts.length != 3) {
      throw FormatException(
        'Invalid JWT format: Expected 3 parts (header, payload, signature).',
      );
    }
  }

  /// Decodes the JWT payload and returns it as a Map.
  static Map<String, dynamic> _decodeJwtPayload(String token) {
    List<String> parts = token.split('.');
    String payloadBase64 = parts[1];
    String normalized = base64.normalize(payloadBase64);
    String decoded = utf8.decode(base64Url.decode(normalized));

    return jsonDecode(decoded) as Map<String, dynamic>;
  }

  /// Verifies that required claims (`iss`, `sub`) are present.
  static void _verifyRequiredClaims(Map<String, dynamic> payload) {
    if (!payload.containsKey('iss') || payload['iss'].toString().isEmpty) {
      throw FormatException('Missing or empty "iss" (issuer) field.');
    }
    if (!payload.containsKey('sub') || payload['sub'].toString().isEmpty) {
      throw FormatException('Missing or empty "sub" (subject) field.');
    }
  }

  /// Verifies expiration (`exp` claim) if present.
  static void _verifyExpiration(Map<String, dynamic> payload) {
    if (payload.containsKey('exp')) {
      int expTimestamp = payload['exp'];
      int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      if (expTimestamp < currentTimestamp) {
        throw FormatException('Token has expired.');
      }
    }
  }

  /// Basic validation: Only checks JWT format.
  static bool basicValidate(String didToken) {
    try {
      _validateJwtFormat(didToken);
      return true;
    } catch (e) {
      throw FormatException('Invalid DID Token: ${e.toString()}');
    }
  }

  /// Full validation: Checks JWT format, required claims, and expiration.
  static bool fullValidate(String didToken) {
    return validate(didToken, checkClaims: true, checkExpiration: true);
  }
}
