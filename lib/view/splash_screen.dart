import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../viewmodels/task_viewmodel.dart';
import 'login_screen.dart';
import 'task_list_screen.dart';

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

    return StreamBuilder(
      stream: auth.user,
      builder: (context, snapshot) {
        if (!_navigated) {
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (!mounted || _navigated) return;
            _navigated = true;
            final user = snapshot.data;
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

        return const Scaffold(
          backgroundColor: Color(0xFF1E6F9F),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'To-Do App',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }
}
