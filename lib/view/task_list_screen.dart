import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_viewmodel.dart';
import '../widgets/task_tile.dart';
import 'add_edit_task_screen.dart';
import 'settings_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchCtrl.addListener(() {
      context.read<TaskViewModel>().setSearchQuery(_searchCtrl.text);
      setState(() {}); // for suffix icon change
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'To-do'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress moved to body with proper height
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text('Completion'),
                const SizedBox(width: 12),
                Expanded(
                  child: LinearProgressIndicator(
                    value: vm.completionProgress,
                    minHeight: 8,
                    backgroundColor: Colors.black12,
                  ),
                ),
                const SizedBox(width: 12),
                Text('${(vm.completionProgress * 100).toStringAsFixed(0)}%'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchCtrl.clear();
                          context.read<TaskViewModel>().clearSearch();
                        },
                      ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<TaskViewModel>().refresh();
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTaskList(context, vm.todoTasks, vm.isLoading),
                  _buildTaskList(context, vm.pendingTasks, vm.isLoading),
                  _buildTaskList(context, vm.completedTasks, vm.isLoading),
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildTaskList(BuildContext context, List<Task> tasks, bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks here'));
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) => TaskTile(task: tasks[i]),
    );
  }
}
