import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../view/login_screen.dart';
import '../view/task_list_screen.dart';
import '../viewmodels/task_viewmodel.dart';

// Splash screen that checks authentication state and navigates accordingly.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final theme = Theme.of(context);

    return StreamBuilder(
      stream: auth.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active && !_navigated) {
          _navigated = true;
          final user = snapshot.data;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (user != null) {
              Provider.of<TaskViewModel>(context, listen: false).init(user.uid);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const TaskListScreen()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          });
        }

        return Scaffold(
          backgroundColor: theme.colorScheme.primary,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'To-Do App',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                CircularProgressIndicator(color: theme.colorScheme.onPrimary),
              ],
            ),
          ),
        );
      },
    );
  }
}