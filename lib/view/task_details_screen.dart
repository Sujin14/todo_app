import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/task_details_view.dart';

// Screen displaying details of a task.
// It uses TaskDetailsView for the body content.
class TaskDetailsScreen extends StatelessWidget {
  final Task task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title),),
      body: SizedBox(
        width: double.infinity,
        child: TaskDetailsView(task: task),
      ),
    );
  }
}
