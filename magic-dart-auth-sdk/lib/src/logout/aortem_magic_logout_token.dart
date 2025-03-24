import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// AortemMagicLogoutByToken
/// 
/// A class responsible for logging out users based on their authentication token.
/// It securely communicates with the Magic API to perform the logout operation.
/// 
/// ## Features:
/// - Ensures the token is valid before sending requests.
/// - Supports an optional stub mode for testing.
/// - Handles API responses and errors gracefully.
///
/// ## Usage Example:
/// ```dart
/// var logoutHandler = AortemMagicLogoutByToken(apiKey: 'your-api-key');
/// await logoutHandler.logoutByToken('user-authentication-token');
/// ```
class AortemMagicLogoutByToken {
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
  AortemMagicLogoutByToken({
    required this.apiKey,
    this.apiBaseUrl = "https://api.magic.com",
    http.Client? client,
    this.useStub = false,
  }) : client = client ?? http.Client();

  /// Logs out a user based on their authentication token.
  /// - Ensures the token is valid before sending the request.
  /// - Uses a mock response if `useStub` is enabled.
  /// - Throws an exception if the API request fails.
  Future<Map<String, dynamic>> logoutByToken(String token) async {
    if (!_isValidToken(token)) {
      throw ArgumentError("Invalid token format.");
    }

    if (useStub) {
      return _mockLogoutResponse(token);
    }

    final uri = Uri.parse("$apiBaseUrl/v1/user/logout");

    final response = await client.post(
      uri,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"token": token}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to log out: ${response.statusCode} - ${response.body}");
    }
  }

  /// Generates a mock response for logout operations (useful for testing).
  /// - Returns a success message for the provided `token`.
  Map<String, dynamic> _mockLogoutResponse(String token) {
    return {
      "success": true,
      "message": "User with token $token logged out successfully.",
    };
  }

  /// Validates the token format (basic check for non-empty string).
  bool _isValidToken(String token) {
    return token.isNotEmpty;
  }
}
