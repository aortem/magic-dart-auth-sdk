

import 'dart:convert';

/// AortemMagicTokenDecoder
/// 
/// A utility class for decoding Decentralized Identifier (DID) Tokens (JWT format).
/// It extracts the payload and optionally verifies required claims.
/// 
/// ## Features:
/// - Decodes the payload of a DID Token.
/// - Supports optional verification to ensure required fields (`iss`, `sub`) are present.
/// - Throws an error if the token format is invalid or required fields are missing.
/// 
/// ## Usage Example:
/// ```dart
/// String didToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2V4YW1wbGUuY29tIiwic3ViIjoiMHgxMjM0NTY3ODlhYmNkZWYiLCJleHAiOjE2NjAwMDAwMDB9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
/// Map<String, dynamic> payload = AortemMagicTokenDecoder.decode(didToken, verify: true);
/// print(payload); // Outputs decoded payload
/// ```
class AortemMagicTokenDecoder {
  /// Decodes a DID Token (JWT format) and returns the payload as a Map.
  /// - [didToken]: The DID Token (JWT format).
  /// - [verify]: If `true`, ensures required fields (`iss`, `sub`) are present.
  ///
  /// Throws an error if the token is invalid or verification fails.
  static Map<String, dynamic> decode(String didToken, {bool verify = false}) {
    if (didToken.isEmpty) {
      throw ArgumentError('DID Token cannot be empty.');
    }

    try {
      // Decode JWT payload
      Map<String, dynamic> payload = _decodeJwtPayload(didToken);

      // Optional verification step
      if (verify) {
        _verifyRequiredFields(payload);
      }

      return payload;
    } catch (e) {
      throw FormatException('Invalid DID Token: ${e.toString()}');
    }
  }

  /// Decodes a JWT and returns the payload as a Map.
  static Map<String, dynamic> _decodeJwtPayload(String token) {
    List<String> parts = token.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid JWT format');
    }

    String payloadBase64 = parts[1];
    String normalized = base64.normalize(payloadBase64);
    String decoded = utf8.decode(base64Url.decode(normalized));

    return jsonDecode(decoded) as Map<String, dynamic>;
  }

  /// Verifies that required claims (`iss`, `sub`) are present in the payload.
  static void _verifyRequiredFields(Map<String, dynamic> payload) {
    if (!payload.containsKey('iss') || payload['iss'].toString().isEmpty) {
      throw FormatException('Missing or empty "iss" field.');
    }
    if (!payload.containsKey('sub') || payload['sub'].toString().isEmpty) {
      throw FormatException('Missing or empty "sub" field.');
    }
  }
}
