import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService(),),
        ChangeNotifierProvider<TaskViewModel(create: (_) => TaskViewModel())
      ],
      child: MaterialApp(
        title: 'To-Do List',
        theme: AppTheme.theme,
        home: const LoginScreen(),
      ),
    );
  }
}
