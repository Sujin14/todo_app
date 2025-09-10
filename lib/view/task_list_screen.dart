import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../viewmodels/task_viewmodel.dart';
import '../widgets/task_card.dart';
import '../widgets/shimmer_task_card.dart';
import '../widgets/search_filter_bar.dart';
import 'add_edit_task_screen.dart';
import 'settings_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> with SingleTickerProviderStateMixin {
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

  Widget _buildList(List<Task> tasks, TaskViewModel vm) {
    if (vm.isLoading) {
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (_, __) => const ShimmerTaskCard(),
      );
    }
    if (vm.isBusy) {
      // show shimmer placeholders while busy (ops)
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (_, __) => const ShimmerTaskCard(),
      );
    }
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks here'));
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
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          )
        ],
        bottom: TabBar(controller: _tabController, tabs: const [
          Tab(text: 'To-do'),
          Tab(text: 'Pending'),
          Tab(text: 'Completed'),
        ]),
      ),
      body: Column(
        children: [
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
          const SearchFilterBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await vm.refresh(),
              child: TabBarView(controller: _tabController, children: [
                _buildList(vm.todoTasks, vm),
                _buildList(vm.pendingTasks, vm),
                _buildList(vm.completedTasks, vm),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditTaskScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
