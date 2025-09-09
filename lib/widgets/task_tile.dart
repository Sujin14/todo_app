import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../view/add_edit_task_screen.dart';
import '../viewmodels/task_viewmodel.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  Color _getPriorityColor(String priority, BuildContext context) {
    switch (priority) {
      case 'High':
        return Colors.red.shade600;
      case 'Low':
        return Colors.green.shade600;
      default:
        return Colors.orange.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskViewModel>(context, listen: false);

    return ListTile(
      title: Text(task.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (task.description.isNotEmpty) Text(task.description),
          if (task.dueDate != null)
            Text('Due: ${DateFormat('MMM dd, yyyy').format(task.dueDate!)}'),
        ],
      ),
      leading: Container(
        width: 10,
        height: double.infinity,
        color: _getPriorityColor(task.priority, context),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status dropdown
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
                // Edit
                // ignore: use_build_context_synchronously
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
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await vm.deleteTask(task.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task deleted')),
                    );
                  }
                }
              }
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'edit', child: ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
              PopupMenuItem(value: 'delete', child: ListTile(leading: Icon(Icons.delete), title: Text('Delete'))),
            ],
          ),
        ],
      ),
    );
  }
}
