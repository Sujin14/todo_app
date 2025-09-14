import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_repository.dart';

// ViewModel for managing tasks, filters, and state.
class TaskViewModel extends ChangeNotifier {
  late TaskRepository _repo;
  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoading = true;
  bool _isBusy = false;
  String _searchQuery = '';
  String _sortBy = 'dueDate';

  bool get isBusy => _isBusy;
  bool get isLoading => _isLoading;

  // Filtered tasks by status.
  List<Task> get todoTasks =>
      _filteredTasks.where((t) => t.status == 'todo').toList();
  List<Task> get pendingTasks =>
      _filteredTasks.where((t) => t.status == 'pending').toList();
  List<Task> get completedTasks =>
      _filteredTasks.where((t) => t.status == 'completed').toList();

  // Completion progress percentage.
  double get completionProgress =>
      _allTasks.isEmpty ? 0.0 : completedTasks.length / _allTasks.length;

  String get sortBy => _sortBy;

  StreamSubscription<List<Task>>? _subscription;

  // Initializes repository and starts listening to tasks stream.
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

  // Refreshes tasks by fetching once.
  Future<void> refresh() async {
    try {
      final tasks = await _repo.fetchTasksOnce();
      _allTasks = tasks;
      _applyFilters();
      notifyListeners();
    } catch (_) {}
  }

  // Sets search query and applies filters.
  void setSearchQuery(String q) {
    _searchQuery = q.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  // Clears search query.
  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  // Sets sort method and applies filters.
  void setSortBy(String sort) {
    _sortBy = sort;
    _applyFilters();
    notifyListeners();
  }

  // Applies search and sort filters to tasks.
  void _applyFilters() {
    _filteredTasks = _allTasks.where((t) {
      final matchesQuery =
          t.title.toLowerCase().contains(_searchQuery) ||
          t.description.toLowerCase().contains(_searchQuery) ||
          t.category.toLowerCase().contains(_searchQuery);
      return matchesQuery;
    }).toList();

    if (_sortBy == 'dueDate') {
      _filteredTasks.sort(
        (a, b) => (a.dueDate ?? DateTime(9999)).compareTo(
          b.dueDate ?? DateTime(9999),
        ),
      );
    } else if (_sortBy == 'priority') {
      const prioMap = {'Low': 0, 'Med': 1, 'High': 2};
      _filteredTasks.sort(
        (a, b) => prioMap[a.priority]!.compareTo(prioMap[b.priority]!),
      );
    } else if (_sortBy == 'category') {
      _filteredTasks.sort((a, b) => a.category.compareTo(b.category));
    }
  }

  // Adds a task with busy state handling.
  Future<void> addTask(Task task) async {
    _setBusy(true);
    try {
      await _repo.addTask(task);
    } finally {
      _setBusy(false);
    }
  }

  // Updates a task with busy state handling.
  Future<void> updateTask(Task task) async {
    _setBusy(true);
    try {
      await _repo.updateTask(task);
    } finally {
      _setBusy(false);
    }
  }

  // Updates task status with busy state handling.
  Future<void> updateStatus(Task task, String status) async {
    _setBusy(true);
    try {
      await _repo.updateStatus(task.id, status);
    } finally {
      _setBusy(false);
    }
  }

  // Deletes a task with busy state handling.
  Future<void> deleteTask(String id) async {
    _setBusy(true);
    try {
      await _repo.deleteTask(id);
    } finally {
      _setBusy(false);
    }
  }

  // Toggles completion with busy state handling.
  Future<void> toggleCompletion(Task task) async {
    _setBusy(true);
    try {
      await _repo.toggleCompletion(task.id, task.isCompleted);
    } finally {
      _setBusy(false);
    }
  }

  // Sets busy state and notifies listeners.
  void _setBusy(bool v) {
    _isBusy = v;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}