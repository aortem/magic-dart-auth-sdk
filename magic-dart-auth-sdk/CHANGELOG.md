## 0.0.2

- **chore**: Remove `ui-debug.log` from the package to avoid committing emulator logs.
- **chore**: Extend commit-message validator (`local_dev_tools/validate_commit_msg.dart`) to allow a new `docs` type.  
- **fix**: Correct trailing-comma placement in the JSON map literal returned by `AortemMagicMultichainMetadataService` to ensure valid Dart syntax.  
- **fix**: Update exception formatting in `AortemMagicLogoutByPublicAddress.logoutByPublicAddress` so multi-line exception messages parse correctly.  
- **refactor**: Standardize method signatures with trailing commas and consistent indentation across:
  - `logoutByPublicAddress(String publicAddress)`  
  - `_mockMetadataResponse(...)` in metadata service  
- **style**: Clean up doc comments in `AortemMagicTokenDecoder` (remove blank `///` lines for consistency).  
- **test**: Reformat parameter lists and add trailing commas in unit tests:
  - `test/unit/auth/aortem_magic_token_decode_test.dart`  
  - `test/unit/utils/aortem_magic_parse_auth_header_test.dart`  

## 0.0.1

- Introduced `MagicHttpException` for improved error reporting in the SDK.
- Updated `MagicAuth.isAuthorized()` logic to improve access token validation.
- Improved response body parsing with safer JSON decoding.
- Enhanced test coverage for error handling and auth validation.

## 0.0.1-pre+2

- update readme

## 0.0.1-pre+1

- Add all methods
- Resolve all issues detected by dart analyze.

## 0.0.1-pre

- Initial pre-release version of the magic Dart Auth SDK.
