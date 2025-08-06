import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for retrieving user metadata across multiple blockchains.
///
/// This service provides methods to fetch metadata using different identifiers,
/// including issuer, public address, and token, in combination with a wallet identifier.
class MagicMultichainMetadataService {
  /// The API key used for authentication with the metadata service.
  final String apiKey;

  /// The base URL for the API requests.
  final String apiBaseUrl;

  /// The HTTP client used to make network requests.
  final http.Client client;

  /// Determines whether to use stub data instead of making real API calls.
  final bool useStub;

  /// Creates an instance of [MagicMultichainMetadataService].
  ///
  /// The [apiKey] is required for authentication. The [apiBaseUrl] defaults to "https://api.magic.com".
  /// An optional [client] can be provided for dependency injection, and [useStub] allows returning
  /// mock responses for testing.
  MagicMultichainMetadataService({
    required this.apiKey,
    this.apiBaseUrl = "https://api.magic.com",
    http.Client? client,
    this.useStub = false,
  }) : client = client ?? http.Client();

  /// Retrieves metadata using an [issuer] and [wallet] identifier.
  ///
  /// Throws an [ArgumentError] if the input values are invalid.
  Future<Map<String, dynamic>> getMetadataByIssuerAndWallet(
    String issuer,
    String wallet,
  ) async {
    return _fetchMetadata("issuer", issuer, wallet);
  }

  /// Retrieves metadata using a [publicAddress] and [wallet] identifier.
  ///
  /// Throws an [ArgumentError] if the input values are invalid.
  Future<Map<String, dynamic>> getMetadataByPublicAddressAndWallet(
    String publicAddress,
    String wallet,
  ) async {
    return _fetchMetadata("public-address", publicAddress, wallet);
  }

  /// Retrieves metadata using a [token] and [wallet] identifier.
  ///
  /// Throws an [ArgumentError] if the input values are invalid.
  Future<Map<String, dynamic>> getMetadataByTokenAndWallet(
    String token,
    String wallet,
  ) async {
    return _fetchMetadata("token", token, wallet);
  }

  /// Fetches metadata via API or returns stubbed response if [useStub] is enabled.
  ///
  /// [type] specifies the identifier type (e.g., "issuer", "public-address", "token").
  /// [identifier] is the value associated with the identifier type.
  /// [wallet] is the wallet address associated with the request.
  ///
  /// Throws an [ArgumentError] if the identifier or wallet is invalid.
  Future<Map<String, dynamic>> _fetchMetadata(
    String type,
    String identifier,
    String wallet,
  ) async {
    if (!_isValid(identifier) || !_isValid(wallet)) {
      throw ArgumentError("Invalid $type or wallet format.");
    }

    if (useStub) {
      return _mockMetadataResponse(type, identifier, wallet);
    }

    final uri = Uri.parse(
      "$apiBaseUrl/v1/user/metadata/$type/$identifier?wallet=$wallet",
    );

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
        "Failed to retrieve metadata: ${response.statusCode} - ${response.body}",
      );
    }
  }

  /// Returns a mock response for metadata retrieval (useful for testing and local development).
  ///
  /// [type] specifies the identifier type, [identifier] is the provided identifier value,
  /// and [wallet] represents the associated wallet address.
  Map<String, dynamic> _mockMetadataResponse(
    String type,
    String identifier,
    String wallet,
  ) {
    return {
      "success": true,
      "message": "Mock metadata retrieved successfully.",
      "data": {
        "identifierType": type,
        "identifier": identifier,
        "wallet": wallet,
        "issuer": "mock_issuer_123",
        "email": "mock@example.com",
        "publicAddress": "0xMockAddress123",
        "createdAt": DateTime.now().toIso8601String(),
      },
    };
  }

  /// Validates that the given [value] is a non-empty string.
  bool _isValid(String value) {
    return value.isNotEmpty;
  }
}
