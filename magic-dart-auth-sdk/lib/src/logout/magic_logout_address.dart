import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// MagicLogoutByPublicAddress
///
/// A class responsible for logging out users based on their public Ethereum-style address.
/// It securely communicates with the Magic API to perform the logout operation.
///
/// ## Features:
/// - Validates public addresses before sending requests.
/// - Supports an optional stub mode for testing.
/// - Handles API responses and errors gracefully.
///
/// ## Usage Example:
/// ```dart
/// var logoutHandler = MagicLogoutByPublicAddress(apiKey: 'your-api-key');
/// await logoutHandler.logoutByPublicAddress('0x1234567890abcdef1234567890abcdef12345678');
/// ```
class MagicLogoutByPublicAddress {
  /// API key required for authentication.
  final String apiKey;

  /// Base URL of the API.
  final String apiBaseUrl;

  /// HTTP client for making API requests.
  final http.Client client;

  /// Flag to enable stub mode for testing without actual API calls.
  final bool useStub;

  /// Constructor for initializing the logout handler.
  /// - Accepts an optional `client` for dependency injection (useful for testing).
  /// - Defaults `apiBaseUrl` to "https://api.magic.com".
  MagicLogoutByPublicAddress({
    required this.apiKey,
    this.apiBaseUrl = "https://api.magic.com",
    http.Client? client,
    this.useStub = false,
  }) : client = client ?? http.Client();

  /// Logs out a user based on their public Ethereum address.
  /// - Validates the address format before sending the request.
  /// - Uses a mock response if `useStub` is enabled.
  /// - Throws an exception if the API request fails.
  Future<Map<String, dynamic>> logoutByPublicAddress(
    String publicAddress,
  ) async {
    if (!_isValidPublicAddress(publicAddress)) {
      throw ArgumentError("Invalid public address format.");
    }

    if (useStub) {
      return _mockLogoutResponse(publicAddress);
    }

    final uri = Uri.parse("$apiBaseUrl/v1/user/logout");

    final response = await client.post(
      uri,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"publicAddress": publicAddress}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Failed to log out: ${response.statusCode} - ${response.body}",
      );
    }
  }

  /// Generates a mock response for logout operations (useful for testing).
  /// - Returns a success message for the provided `publicAddress`.
  Map<String, dynamic> _mockLogoutResponse(String publicAddress) {
    return {
      "success": true,
      "message":
          "User with public address $publicAddress logged out successfully.",
    };
  }

  /// Validates an Ethereum-style public address.
  /// - The address must start with "0x" followed by 40 hexadecimal characters.
  /// - Returns `true` if the address is valid, otherwise `false`.
  bool _isValidPublicAddress(String address) {
    final regex = RegExp(r"^0x[a-fA-F0-9]{40}$");
    return regex.hasMatch(address);
  }
}
