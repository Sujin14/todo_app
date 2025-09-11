// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_viewmodel.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  DateTime? _dueDate;
  String _priority = 'Med';
  String _category = 'General';

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task?.title ?? '');
    _descCtrl = TextEditingController(text: widget.task?.description ?? '');
    _dueDate = widget.task?.dueDate;
    _priority = widget.task?.priority ?? 'Med';
    _category = widget.task?.category ?? 'General';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  bool get _isPastDue {
    final d = widget.task?.dueDate;
    if (d == null) return false;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).isAfter(DateTime(d.year, d.month, d.day));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskViewModel>(context, listen: false);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Add Task' : 'Edit Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Title required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(_dueDate == null ? 'Select Due Date' : DateFormat('MMM dd, yyyy').format(_dueDate!)),
              trailing: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _dueDate = picked);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: const InputDecoration(labelText: 'Priority', border: OutlineInputBorder()),
              items: const ['Low', 'Med', 'High'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (v) => setState(() => _priority = v ?? 'Med'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
              items: const ['General', 'Work', 'Personal', 'Study'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v ?? 'General'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  if (widget.task != null && _isPastDue && (widget.task!.status != 'completed')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cannot edit — task is past due', style: TextStyle(color: theme.colorScheme.onSurface))),
                    );
                    return;
                  }

                  final newTask = (widget.task ?? const Task(title: ''))
                      .copyWith(
                        title: _titleCtrl.text.trim(),
                        description: _descCtrl.text.trim(),
                        dueDate: _dueDate,
                        priority: _priority,
                        category: _category,
                      );

                  try {
                    if (widget.task == null) {
                      await vm.addTask(newTask);
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task added', style: TextStyle(color: theme.colorScheme.onSurface))));
                    } else {
                      await vm.updateTask(newTask);
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task updated', style: TextStyle(color: theme.colorScheme.onSurface))));
                    }
                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e', style: TextStyle(color: theme.colorScheme.onSurface))));
                  }
                },
                child: const Text('Save'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}