import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// UserMetadataByToken
///
/// A class responsible for fetching user metadata using an authentication token.
/// It securely communicates with the Magic API to retrieve user details.
///
/// ## Features:
/// - Ensures the token is valid before sending requests.
/// - Fetches metadata including issuer, email, and creation timestamp.
/// - Handles API responses and errors gracefully.
///
/// ## Usage Example:
/// ```dart
/// var metadataHandler = UserMetadataByToken(apiKey: 'your-api-key');
/// var metadata = await metadataHandler.getMetadataByToken('user-authentication-token');
/// print(metadata);
/// ```
class AortemMagicUserMetadataByToken {
  /// API key required for authentication.
  final String apiKey;

  /// Base URL of the API.
  final String apiBaseUrl;

  /// HTTP client for making API requests.
  final http.Client client;

  /// Constructor for initializing the metadata handler.
  /// - Accepts an optional `client` for dependency injection (useful for testing).
  /// - Defaults `apiBaseUrl` to "https://api.magic.com".
  AortemMagicUserMetadataByToken({
    required this.apiKey,
    this.apiBaseUrl = "https://api.magic.com",
    http.Client? client,
  }) : client = client ?? http.Client();

  /// Fetches metadata using a provided authentication token.
  /// - Ensures the token is not empty before sending the request.
  /// - Throws an exception if the API request fails.
  Future<Map<String, dynamic>> getMetadataByToken(String token) async {
    if (token.isEmpty) {
      throw ArgumentError("Token cannot be empty.");
    }

    final uri = Uri.parse("$apiBaseUrl/v1/user/metadata?token=$token");

    final response = await client.get(
      uri,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Failed to fetch metadata: ${response.statusCode} - ${response.body}");
    }
  }
}
