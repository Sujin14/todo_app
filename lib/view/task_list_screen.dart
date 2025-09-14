import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../view/add_edit_task_screen.dart';
import '../view/settings_screen.dart';
import '../viewmodels/task_viewmodel.dart';
import '../widgets/completion_progress.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/shimmer_task_card.dart';
import '../widgets/task_card.dart';

// Main screen listing tasks in tabs: To-do, Pending, Completed.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Builds the list of tasks or shimmer placeholders if loading.
  Widget _buildList(List<Task> tasks, TaskViewModel vm) {
    if (vm.isLoading || vm.isBusy) {
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (_, __) => const ShimmerTaskCard(),
      );
    }
    if (tasks.isEmpty) {
      return SizedBox(
        height: 200,
        child: Lottie.asset('assets/animations/no_data.json'),
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (_, i) => TaskCard(task: tasks[i]),
    );
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
          tabs: [
            Tab(text: 'To-do'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CompletionProgress(),
          ),
          const SearchFilterBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await vm.refresh(),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildList(vm.todoTasks, vm),
                  _buildList(vm.pendingTasks, vm),
                  _buildList(vm.completedTasks, vm),
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
}
