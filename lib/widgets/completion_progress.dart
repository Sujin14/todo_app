import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_viewmodel.dart';

// Widget displaying task completion progress bar.
class CompletionProgress extends StatelessWidget {
  const CompletionProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskViewModel>(context);
    final theme = Theme.of(context);

    return Row(
      children: [
        Text('Completion', style: TextStyle(color: theme.colorScheme.onSurface)),
        const SizedBox(width: 12),
        Expanded(
          child: LinearProgressIndicator(
            value: vm.completionProgress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
        ),
        const SizedBox(width: 12),
        Text('${(vm.completionProgress * 100).toStringAsFixed(0)}%', style: TextStyle(color: theme.colorScheme.onSurface)),
      ],
    );
  }
}