/// Utility class for handling Authorization headers.
class AortemMagicAuthHeaderParse {
  /// Parses the [authorizationHeader] and extracts the token.
  ///
  /// This method expects the header to be in the format: `"Bearer <token>"`.
  ///
  /// - If the header is empty, it throws an [ArgumentError].
  /// - If the format is incorrect, it throws an [ArgumentError] indicating the expected format.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   String token = MagicUtils.parseAuthorizationHeader("Bearer myAccessToken123");
  ///   print("Extracted Token: $token"); // Output: myAccessToken123
  /// } catch (e) {
  ///   print("Error: $e");
  /// }
  /// ```
  ///
  /// Returns the extracted token as a [String].
  static String parseAuthorizationHeader(String authorizationHeader) {
    if (authorizationHeader.isEmpty) {
      throw ArgumentError('Authorization header cannot be empty.');
    }

    // Trim any leading or trailing spaces
    final trimmedHeader = authorizationHeader.trim();

    // Simple String Splitting Approach
    final parts = trimmedHeader.split(' ');
    if (parts.length == 2 && parts[0].toLowerCase() == 'bearer') {
      return parts[1]; // Return the extracted token
    }

    // Regular Expression Approach (for extra robustness)
    final regex = RegExp(r'^[Bb]earer\s+(.+)$');
    final match = regex.firstMatch(trimmedHeader);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!; // Extract token using regex
    }

    throw ArgumentError(
      'Invalid Authorization header format. Expected "Bearer <token>".',
    );
  }
}
