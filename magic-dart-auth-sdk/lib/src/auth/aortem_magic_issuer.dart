/// AortemMagicIssuerExtractor
/// 
/// A utility class for extracting the issuer (`iss`) field from a Decentralized Identifier (DID) Token.
/// This class provides strict and loose validation modes to ensure the extracted issuer follows the expected format.
/// 
/// ## Features:
/// - Extracts the `iss` field from a DID Token (JWT format).
/// - Supports strict validation mode (must be a valid URL format).
/// - Supports loose validation mode (only checks for a recognizable domain format).
/// - Throws an error if the token is invalid or the issuer format is incorrect.
/// 
/// ## Usage Example:
/// ```dart
/// String didToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2V4YW1wbGUuY29tIn0.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
/// String issuer = AortemMagicIssuerExtractor.getIssuer(didToken, strict: true);
/// print(issuer); // Outputs: https://example.com
/// ```
import 'dart:convert';

class AortemMagicIssuerExtractor {
  /// Extracts the issuer (`iss`) from a DID Token.
  /// - [didToken]: The DID Token (JWT format).
  /// - [strict]: If `true`, enforces strict validation (must be a valid URL format).
  ///
  /// Throws an error if the token is invalid or the issuer format is incorrect.
  static String getIssuer(String didToken, {bool strict = true}) {
    if (didToken.isEmpty) {
      throw ArgumentError('DID Token cannot be empty.');
    }

    try {
      // Decode JWT payload (second part of the token)
      Map<String, dynamic> payload = _decodeJwtPayload(didToken);

      // Extract issuer from "iss" field
      String? issuer = payload['iss'];

      if (issuer == null || issuer.isEmpty) {
        throw FormatException('Issuer (iss) is missing in the DID Token.');
      }

      // Validate based on strict or loose mode
      if (strict) {
        if (!_isValidStrictIssuer(issuer)) {
          throw FormatException('Invalid issuer format in strict mode.');
        }
      } else {
        if (!_isValidLooseIssuer(issuer)) {
          throw FormatException('Invalid issuer format in loose mode.');
        }
      }

      return issuer;
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

  /// Strict validation: Must be a valid URL.
  static bool _isValidStrictIssuer(String issuer) {
    final uri = Uri.tryParse(issuer);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  /// Loose validation: Must be non-empty and contain a recognizable domain format.
  static bool _isValidLooseIssuer(String issuer) {
    return issuer.isNotEmpty && issuer.contains('.');
  }
}
