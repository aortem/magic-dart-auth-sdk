import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

// UserMetadataByPublicAddress
///
/// A class responsible for fetching user metadata based on their public address.
/// It securely communicates with the Magic API to retrieve user details.
///
/// ## Features:
/// - Ensures the public address is valid before sending requests.
/// - Supports an optional stub mode for testing.
/// - Handles API responses and errors gracefully.
///
/// ## Usage Example:
/// ```dart
/// var metadataHandler = UserMetadataByPublicAddress(apiKey: 'your-api-key');
/// var metadata = await metadataHandler.getMetadataByPublicAddress('user-public-address');
/// print(metadata);
/// ```
class AortemMagicUserMetadataByPublicAddress {
  /// API key required for authentication.
  final String apiKey;

  /// Base URL of the API.
  final String apiBaseUrl;

  /// HTTP client for making API requests.
  final http.Client client;

  /// Constructor for initializing the metadata handler.
  /// - Accepts an optional `client` for dependency injection (useful for testing).
  /// - Defaults `apiBaseUrl` to "https://api.magic.com".
  AortemMagicUserMetadataByPublicAddress({
    required this.apiKey,
    this.apiBaseUrl = "https://api.magic.com",
    http.Client? client,
  }) : client = client ?? http.Client();

  /// Fetches user metadata by public address.
  /// - Ensures the public address is not empty before sending the request.
  /// - Uses a mock response if `useStub` is enabled.
  /// - Throws an exception if the API request fails.
  Future<Map<String, dynamic>> getMetadataByPublicAddress(String publicAddress,
      {bool useStub = false}) async {
    if (publicAddress.isEmpty) {
      throw ArgumentError("Public address cannot be empty.");
    }

    // Return stub data for testing purposes
    if (useStub) {
      return {
        "issuer": "did:magic:$publicAddress",
        "email": "user@example.com",
        "publicAddress": publicAddress,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      };
    }

    final uri =
        Uri.parse("$apiBaseUrl/v1/user/metadata?public_address=$publicAddress");

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
