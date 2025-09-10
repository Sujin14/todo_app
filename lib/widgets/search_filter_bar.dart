import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_viewmodel.dart';

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({super.key});
  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      context.read<TaskViewModel>().setSearchQuery(_ctrl.text);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final vm = context.read<TaskViewModel>();
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Sort by Date'),
                onTap: () {
                  vm.setSortBy('dueDate');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.priority_high),
                title: const Text('Sort by Priority'),
                onTap: () {
                  vm.setSortBy('priority');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.label),
                title: const Text('Sort by Category'),
                onTap: () {
                  vm.setSortBy('category');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                hintText: 'Search tasks (title, desc, category)...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _ctrl.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _ctrl.clear();
                          context.read<TaskViewModel>().clearSearch();
                        },
                      ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _showFilterMenu,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Sort / Filter',
          ),
        ],
      ),
    );
  }
}
