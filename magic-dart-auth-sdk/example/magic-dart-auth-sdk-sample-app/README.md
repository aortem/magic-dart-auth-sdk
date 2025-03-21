# magic-dart-sample-app

## Description

A sample app to showcase the process of installing, setting up and using the magic_dart_auth_sdk

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)

## Installation

- Add the absolute path of the magic_dart_auth_sdk to the sample app's pubspec.yaml file
  ```yaml
  dependencies:
  magic_dart_auth_sdk:
    path: /Users/user/Documents/GitLab/magic_dart_auth_sdk/magic_dart_auth_sdk
  ```

## Usage

    Depending on the platform magic_dart_auth_sdk can be initialized via three methods

**Web:**
For Web we use Enviroment Variable

```
import 'package:flutter/material.dart';
import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

    void main() async
    {

        magicApp.initializeAppWithEnvironmentVariables(apiKey:'api_key',projectId: 'project_id',);

        magicApp.instance.getAuth();

        runApp(const MyApp());
    }

```

- Import the magic_dart_auth_sdk and the material app
  ```
  import 'package:flutter/material.dart';
  import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';
  ```
- In the main function call the 'magicApp.initializeAppWithEnvironmentVariables' and pass in your api key and project id

  ```
    magicApp.initializeAppWithEnvironmentVariables(apiKey:'api_key',projectId: 'project_id',);
  ```

- Aftwards call the 'magicApp.instance.getAuth()'
  ```
    magicApp.instance.getAuth();
  ```
- Then call the 'runApp(const MyApp())' method

  ```
      runApp(const MyApp())

  ```

**Mobile:**
For mobile we can use either [Service Account](#serviceaccount) or [Service account impersonation](#ServiceAccountImpersonation)

## ServiceAccount

    ```
    import 'package:flutter/material.dart';
    import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

    void main() async
    {
        magicApp.initializeAppWithServiceAccount(serviceAccountKeyFilePath: 'path_to_json_file');

        magicApp.instance.getAuth();
        runApp(const MyApp());
    }
    ```

- Import the magic_dart_auth_sdk and the material app

  ```
  import 'package:flutter/material.dart';
  import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';
  ```

- In the main function call the 'magicApp.initializeAppWithServiceAccount' function and pass the path to your the json file
  ```
   magicApp.initializeAppWithServiceAccount(serviceAccountKeyFilePath: 'path_to_json_file');
  ```
- Aftwards call the 'magicApp.instance.getAuth()'
  ```
    magicApp.instance.getAuth();
  ```
- Then call the 'runApp(const MyApp())' method

  ```
      runApp(const MyApp())

  ```

## ServiceAccountImpersonation

    ```
    import 'package:flutter/material.dart';
    import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';

    void main() async
    {
        magicApp.initializeAppWithServiceAccountImpersonation(serviceAccountEmail: service_account_email, userEmail: user_email)

        magicApp.instance.getAuth();
        runApp(const MyApp());
    }
    ```

- Import the magic_dart_auth_sdk and the material app

  ```
  import 'package:flutter/material.dart';
  import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';
  ```

- In the main function call the 'magicApp.initializeAppWithServiceAccountImpersonation' function and pass the service_account_email and user_email
  ```
    magicApp.initializeAppWithServiceAccountImpersonation(serviceAccountEmail: serviceAccountEmail,userEmail:userEmail,)
  ```
- Aftwards call the 'magicApp.instance.getAuth()'
  ```
    magicApp.instance.getAuth();
  ```
- Then call the 'runApp(const MyApp())' method

  ```
      runApp(const MyApp())

  ```
