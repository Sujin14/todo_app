import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  late TaskRepository _repo;
  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _sortBy = 'dueDate';

  List<Task> get todoTasks => _filteredTasks.where((t) => t.status == 'todo').toList();
  List<Task> get pendingTasks => _filteredTasks.where((t) => t.status == 'pending').toList();
  List<Task> get completedTasks => _filteredTasks.where((t) => t.status == 'completed').toList();

  bool get isLoading => _isLoading;
  double get completionProgress =>
      _allTasks.isEmpty ? 0.0 : completedTasks.length / _allTasks.length;
  String get sortBy => _sortBy;

  StreamSubscription<List<Task>>? _subscription;

  void init(String userId) {
    _repo = TaskRepository(userId: userId);
    _isLoading = true;
    notifyListeners();
    _subscription?.cancel();
    _subscription = _repo.getTasks().listen(
      (tasks) {
        _allTasks = tasks;
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> refresh() async {
    try {
      final tasks = await _repo.fetchTasksOnce();
      _allTasks = tasks;
      _applyFilters();
      notifyListeners();
    } catch (_) {
      // ignore
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredTasks = _allTasks
        .where((t) =>
            t.title.toLowerCase().contains(_searchQuery) ||
            t.description.toLowerCase().contains(_searchQuery))
        .toList();
    if (_sortBy == 'dueDate') {
      _filteredTasks.sort(
        (a, b) => (a.dueDate ?? DateTime(9999)).compareTo(b.dueDate ?? DateTime(9999)),
      );
    } else if (_sortBy == 'priority') {
      const prioMap = {'Low': 0, 'Med': 1, 'High': 2};
      _filteredTasks.sort((a, b) => prioMap[a.priority]!.compareTo(prioMap[b.priority]!));
    }
  }

  Future<void> addTask(Task task) async {
    await _repo.addTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _repo.updateTask(task);
  }

  Future<void> updateStatus(Task task, String status) async {
    await _repo.updateStatus(task.id, status);
  }

  Future<void> deleteTask(String id) async {
    await _repo.deleteTask(id);
  }

  Future<void> toggleCompletion(Task task) async {
    await _repo.toggleCompletion(task.id, task.isCompleted);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
