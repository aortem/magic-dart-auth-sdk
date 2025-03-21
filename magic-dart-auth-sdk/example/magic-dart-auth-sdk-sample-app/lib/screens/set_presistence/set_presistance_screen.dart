import 'dart:developer';

import 'package:magic_dart_auth_sdk/magic_dart_auth_sdk.dart';
import 'package:flutter/material.dart';

import 'magic_presistance.dart';

class PersistenceSelectorDropdown extends StatefulWidget {
  const PersistenceSelectorDropdown({super.key});

  @override
  State<PersistenceSelectorDropdown> createState() =>
      _PersistenceSelectorDropdownState();
}

class _PersistenceSelectorDropdownState
    extends State<PersistenceSelectorDropdown> {
  String? _selectedPersistence;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: DropdownButton<String>(
        value: _selectedPersistence,
        hint: const Text('Choose Persistence Option'),
        onChanged: (String? newValue) async {
          setState(() {
            _selectedPersistence = newValue;
          });
          if (newValue != null) {
            if (_selectedPersistence != null) {
              try {
                await magicApp.magicAuth?.setPresistanceMethod(
                    _selectedPersistence!, 'firebasdartadminauthsdk');
                //  log("response of pressitance $response");
              } catch (e) {
                log("response of pressitance $e");
              }
            }
          }
        },
        items: const [
          DropdownMenuItem(
            value: magicPersistence.local,
            child: Text('Local'),
          ),
          DropdownMenuItem(
            value: magicPersistence.session,
            child: Text('Session'),
          ),
          DropdownMenuItem(
            value: magicPersistence.none,
            child: Text('None'),
          ),
        ],
      ),
    ));
  }
}
