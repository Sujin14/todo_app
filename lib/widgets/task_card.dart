import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../view/add_edit_task_screen.dart';
import '../view/task_details_screen.dart';
import '../viewmodels/task_viewmodel.dart';

// Card widget representing a single task in the list.
class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  // Gets color based on priority.
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

  // Checks if the task is past due.
  bool get _isPastDue {
    final d = task.dueDate;
    if (d == null) return false;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).isAfter(DateTime(d.year, d.month, d.day));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskViewModel>(context, listen: false);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: scheme.surface,
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 64,
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority, scheme),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: task)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (task.description.isNotEmpty) Expanded(child: Text(task.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: scheme.onSurface))),
                          const SizedBox(width: 8),
                          Chip(label: Text(task.category)),
                        ],
                      ),
                      if (task.dueDate != null) const SizedBox(height: 8),
                      if (task.dueDate != null)
                        Text('Due: ${DateFormat('MMM dd, yyyy').format(task.dueDate!)}',
                            style: TextStyle(color: _isPastDue ? scheme.error : scheme.onSurface.withOpacity(0.6))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: task.status,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'todo', child: Text('To-do')),
                      DropdownMenuItem(value: 'pending', child: Text('Pending')),
                      DropdownMenuItem(value: 'completed', child: Text('Completed')),
                    ],
                    onChanged: (val) async {
                      if (val == null || val == task.status) return;

                      if (val == 'completed' && _isPastDue && task.status != 'completed') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cannot mark as completed — task past due date')),
                        );
                        return;
                      }

                      await vm.updateStatus(task, val);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Moved to ${val[0].toUpperCase()}${val.substring(1)}')),
                        );
                      }
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
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
                      } else if (value == 'delete') {
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
                          }
                        }
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
                      PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete), title: Text('Delete'))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}