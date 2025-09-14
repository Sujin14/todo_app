import 'package:flutter/material.dart';
import '../widgets/settings_list.dart';

// Settings screen displaying a list of settings options.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const SettingsList(),
    );
  }
}