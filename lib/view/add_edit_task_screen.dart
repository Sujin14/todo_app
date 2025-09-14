// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/add_edit_task_form.dart';

// Screen for adding or editing a task.
// It uses AddEditTaskForm widget for the UI.
class AddEditTaskScreen extends StatelessWidget {
  final Task? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task == null ? 'Add Task' : 'Edit Task')),
      body: AddEditTaskForm(task: task),
    );
  }
}