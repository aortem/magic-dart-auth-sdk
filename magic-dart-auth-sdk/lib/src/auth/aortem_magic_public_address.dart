/// AortemMagicPublicAddressExtractor
/// 
/// A utility class for extracting the public address from a Decentralized Identifier (DID) Token.
/// This class provides strict and loose validation modes to ensure the extracted address follows the expected format.
/// 
/// ## Features:
/// - Extracts the `sub` field from a DID Token (JWT format) to retrieve the public Ethereum address.
/// - Supports strict validation mode (must be a valid Ethereum address format: `0x` followed by 40 hexadecimal characters).
/// - Supports loose validation mode (only checks for the `0x` prefix and non-empty content).
/// - Throws an error if the token is invalid or the address format is incorrect.
/// 
/// ## Usage Example:
/// ```dart
/// String didToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIweDEyMzQ1Njc4OWFiY2RlZjAxMjM0NTY3ODlhYmNkZWYwIn0.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";
/// String publicAddress = AortemMagicPublicAddressExtractor.getPublicAddress(didToken, strict: true);
/// print(publicAddress); // Outputs: 0x123456789abcdef0123456789abcdef0123456789
/// ```
import 'dart:convert';

class AortemMagicPublicAddressExtractor {
  /// Extracts the public address from a DID Token without external dependencies.
  /// - [didToken]: The DID Token (JWT format).
  /// - [strict]: If `true`, enforces strict Ethereum address validation.
  ///
  /// Throws an error if the token is invalid or the address format is incorrect.
  static String getPublicAddress(String didToken, {bool strict = true}) {
    if (didToken.isEmpty) {
      throw ArgumentError('DID Token cannot be empty.');
    }

    try {
      // Decode JWT payload (second part of the token)
      Map<String, dynamic> payload = _decodeJwtPayload(didToken);

      // Extract public address from "sub" field
      String? publicAddress = payload['sub'];

      if (publicAddress == null || publicAddress.isEmpty) {
        throw FormatException(
            'Public address (sub) is missing in the DID Token.');
      }

      // Validate based on strict or loose mode
      if (strict) {
        if (!_isValidStrictEthereumAddress(publicAddress)) {
          throw FormatException(
              'Invalid Ethereum address format in strict mode.');
        }
      } else {
        if (!_isValidLooseEthereumAddress(publicAddress)) {
          throw FormatException(
              'Invalid Ethereum address format in loose mode.');
        }
      }

      return publicAddress;
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

  /// Strict validation: Must start with `0x` and be exactly 42 characters long (Ethereum address).
  static bool _isValidStrictEthereumAddress(String address) {
    final ethRegex = RegExp(r"^0x[a-fA-F0-9]{40}$");
    return ethRegex.hasMatch(address);
  }

  /// Loose validation: Must start with `0x` and be non-empty.
  static bool _isValidLooseEthereumAddress(String address) {
    return address.startsWith('0x') && address.length > 2;
  }
}
