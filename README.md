<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
    <img align="center" alt="Aortem Logo" src="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
  </picture>
</p>

<!-- x-hide-in-docs-end -->
<p align="center" class="github-badges">
  <!-- GitHub Tag Badge -->
  <a href="https://github.com/aortem/magic-dart-auth-sdk/tags">
    <img alt="GitHub Tag" src="https://img.shields.io/github/v/tag/aortem/magic-dart-auth-sdk?style=for-the-badge" />
  </a>
  <!-- Dart-Specific Badges -->
  <a href="https://pub.dev/packages/magic_dart_auth_sdk">
    <img alt="Pub Version" src="https://img.shields.io/pub/v/magic_dart_auth_sdk.svg?style=for-the-badge" />
  </a>
  <a href="https://dart.dev/">
    <img alt="Built with Dart" src="https://img.shields.io/badge/Built%20with-Dart-blue.svg?style=for-the-badge" />
  </a>
<!-- x-hide-in-docs-start -->

# Magic Dart Auth SDK

Magic Dart Auth SDK is designed to provide select out of the box features of Magic in Dart.  Both low level and high level abstractions are provided.

## Features
This implementation does not yet support all functionalities of the Magic authentication service. Here is a list of functionalities with the current support status:

| #  | Method                                                     | Supported |
|----|------------------------------------------------------------|:---------:|
| 1  | Constuctors                                                | ✅        |
| 2  | API Key Validation, Secure Storage, and Dynamic Updates    | ✅        |
| 3  | getPublicAddress Method with Flexible Validationns         | ✅        |
| 4  | getIssuer Method With Flexible Validation Options          | ✅        |
| 5  | decode Method with Flexible Options                        | ✅        |
| 6  | validate Method with Flexible Options                      | ✅        |
| 7  | validate` Method with Flexible Options                     | ✅        |
| 8  | getMetadataByPublicAddress Method with Flexible Options    | ✅        |
| 9  | getMetadataByToken` Method with Flexible Options           | ✅        |
| 10 | logoutByIssuer` Method with Flexible Options               | ✅        |
| 11 | logoutByPublicAddress` Method with Flexible Options        | ✅        |
| 12 | logoutByToken` Method with Flexible Options                | ✅        |
| 13 | Implement Multichain Metadata Retrieval Methods            | ✅        |
| 14 | parseAuthorizationHeader                                   | ✅        |

## Available Versions

Magic Dart Auth SDK is available in two versions to cater to different needs:

1. **Main - Stable Version**: Usually one release a month.  This version attempts to keep stability without introducing breaking changes.
2. **Sample Apps - FrontEnd Version**: The sample apps are provided in various frontend languages in order to allow maximum flexibility with your frontend implementation with the Dart backend.  Note that new features are first tested in the sample apps before being released in the mainline branch. Use only as a guide for your frontend/backend implementation of Dart.

## Documentation

For detailed guides, API references, and example projects, visit our [Magic Dart Auth SDK Documentation](https://sdks.aortem.io/magic-dart-auth-sdk). Start building with  Magic Dart Auth SDK today and take advantage of its robust features and elegant syntax.

## Examples

Explore the `/example` directory in this repository to find sample applications demonstrating  Magic Dart Auth SDK's capabilities in real-world scenarios.

## Contributing

We welcome contributions of all forms from the community! If you're interested in helping improve  Magic Dart Auth SDK, please fork the repository and submit your pull requests. For more details, check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide.  Our team will review your pull request. Once approved, we will integrate your changes into our primary repository and push the mirrored changes on the main github branch.

## Support

For support across all Aortem open-source products, including this SDK, visit our [Support Page](https://aortem.io/support).

## Licensing

The **Magic Dart Auth SDK** is licensed under a dual-license approach:

1. **BSD-3 License**:
   - Applies to all packages and libraries in the SDK.
   - Allows use, modification, and redistribution, provided that credit is given and compliance with the BSD-3 terms is maintained.
   - Permits usage in open-source projects, applications, and private deployments.

2. **Enhanced License Version 2 (ELv2)**:
   - Applies to all use cases where the SDK or its derivatives are offered as part of a **cloud service**.
   - This ensures that the SDK cannot be directly used by cloud providers to offer competing services without explicit permission.
   - Example restricted use cases:
     - Including the SDK in a hosted SaaS authentication platform.
     - Offering the SDK as a component of a managed cloud service.

### **Summary**
- You are free to use the SDK in your applications, including open-source and commercial projects, as long as the SDK is not directly offered as part of a third-party cloud service.
- For details, refer to the [LICENSE](LICENSE.md) file.

## Enhance with Magic Dart Auth SDK

We hope the Magic Dart Auth SDK helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!  test