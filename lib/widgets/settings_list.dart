import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../view/login_screen.dart';

// List widget for settings options, including version and logout.
class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  // Handles logout with confirmation dialog.
  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'Are you sure you want to logout? You will need to log in again to access your tasks.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    await context.read<AuthService>().signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('Version'),
          subtitle: const Text('1.0.0'),
        ),
        ListTile(
          leading: Icon(
            Icons.logout,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('Log out'),
          onTap: () => _logout(context),
        ),
      ],
    );
  }
}