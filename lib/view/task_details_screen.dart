import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_viewmodel.dart';
import 'add_edit_task_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;
  const TaskDetailsScreen({super.key, required this.task});

  bool get _isPastDue {
    final d = task.dueDate;
    if (d == null) return false;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).isAfter(DateTime(d.year, d.month, d.day));
  }

  Color _getPriorityColor(String priority, ColorScheme scheme) {
    switch (priority) {
      case 'High':
        return scheme.error;
      case 'Med':
        return scheme.tertiary;
      case 'Low':
        return scheme.secondary;
      default:
        return scheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (_isPastDue && task.status != 'completed') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cannot edit — task is past due')),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete task?'),
                  content: const Text('This action cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                  ],
                ),
              );
              if (confirmed == true) {
                await vm.deleteTask(task.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task deleted')));
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description', style: theme.textTheme.titleLarge?.copyWith(color: scheme.onSurface)),
                const SizedBox(height: 8),
                Text(task.description.isEmpty ? 'No description' : task.description, style: TextStyle(color: scheme.onSurface)),
                const SizedBox(height: 24),
                Text('Due Date', style: theme.textTheme.titleLarge?.copyWith(color: scheme.onSurface)),
                const SizedBox(height: 8),
                Text(
                  task.dueDate != null ? DateFormat('MMM dd, yyyy').format(task.dueDate!) : 'No due date',
                  style: TextStyle(color: _isPastDue ? scheme.error : scheme.onSurface),
                ),
                const SizedBox(height: 24),
                Text('Priority', style: theme.textTheme.titleLarge?.copyWith(color: scheme.onSurface)),
                const SizedBox(height: 8),
                Chip(
                  label: Text(task.priority, style: TextStyle(color: scheme.onPrimary)),
                  backgroundColor: _getPriorityColor(task.priority, scheme),
                ),
                const SizedBox(height: 24),
                Text('Category', style: theme.textTheme.titleLarge?.copyWith(color: scheme.onSurface)),
                const SizedBox(height: 8),
                Chip(label: Text(task.category)),
                const SizedBox(height: 24),
                Text('Status', style: theme.textTheme.titleLarge?.copyWith(color: scheme.onSurface)),
                const SizedBox(height: 8),
                Chip(label: Text(task.status)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}