import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// UserMetaDataByIssuer
///
/// A class responsible for fetching user metadata based on the issuer identifier.
/// It securely communicates with the Magic API to retrieve user details.
///
/// ## Features:
/// - Ensures the issuer is valid before sending requests.
/// - Handles API responses and errors gracefully.
/// - Allows dependency injection for testing with mock clients.
///
/// ## Usage Example:
/// ```dart
/// var metadataFetcher = UserMetaDataByIssuer(apiKey: 'your-api-key');
/// var userMetadata = await metadataFetcher.getMetadataByIssuer('issuer-identifier');
/// print(userMetadata);
/// ```
class AortemMagicUserMetaDataByIssuer {
  /// API key required for authentication.
  final String apiKey;

  /// Base URL of the API.
  final String apiBaseUrl;

  /// HTTP client for making API requests.
  final http.Client client;

  /// Constructor for initializing the metadata fetcher.
  /// - Accepts an optional `client` for dependency injection (useful for testing).
  /// - Defaults `apiBaseUrl` to "https://api.magic.com".
  AortemMagicUserMetaDataByIssuer({
    required this.apiKey,
    this.apiBaseUrl = "https://api.magic.link",
    http.Client? client,
  }) : client = client ?? http.Client(); // Allow passing a mock client

  /// Fetches metadata by issuer identifier.
  /// - Ensures the issuer is not empty before sending the request.
  /// - Throws an exception if the API request fails.
  Future<Map<String, dynamic>> getMetadataByIssuer(String issuer) async {
    if (issuer.isEmpty) {
      throw ArgumentError("Issuer cannot be empty.");
    }

    final uri = Uri.parse("$apiBaseUrl/v1/user/metadata?issuer=$issuer");
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
        "Failed to fetch metadata: ${response.statusCode} - ${response.body}",
      );
    }
  }
}
