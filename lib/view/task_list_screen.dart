import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/task.dart';
import '../viewmodels/task_viewmodel.dart';
import '../widgets/task_tile.dart';
import 'add_edit_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                value: vm.completionProgress,
                strokeWidth: 4,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                backgroundColor: Colors.grey,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: vm.setSearchQuery,
                        decoration: const InputDecoration(
                          hintText: 'Search tasks...',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: vm._sortBy,
                      icon: const Icon(Icons.sort),
                      items: const [
                        DropdownMenuItem(value: 'dueDate', child: Text('Due Date')),
                        DropdownMenuItem(value: 'priority', child: Text('Priority')),
                      ],
                      onChanged: (val) => vm.setSortBy(val ?? 'dueDate'),
                    ),
                  ],
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Pending'),
                  Tab(text: 'Completed'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return TabBarView(
              children: [
                _buildTaskList(context, vm.pendingTasks, vm.isLoading, isWide),
                _buildTaskList(context, vm.completedTasks, vm.isLoading, isWide),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(
      BuildContext context, List<Task> tasks, bool isLoading, bool isWide) {
    if (isLoading) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey[700]!,
          highlightColor: Colors.grey[600]!,
          child: const ListTile(
            title: SizedBox(height: 20, width: double.infinity),
            subtitle: SizedBox(height: 10, width: double.infinity),
          ),
        ),
      );
    }
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks here'));
    }
    return isWide
        ? GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: tasks.length,
            itemBuilder: (_, i) => TaskTile(task: tasks[i]),
          )
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, i) => TaskTile(task: tasks[i]),
          );
  }
}