import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

// Repository class for managing tasks in Firestore for a specific user.
class TaskRepository {
  final String userId;
  TaskRepository({required this.userId});

  // Reference to the user's tasks collection.
  CollectionReference<Map<String, dynamic>> get _tasks => FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .collection('tasks');

  // Stream of tasks ordered by due date.
  Stream<List<Task>> getTasks() {
    return _tasks
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Task.fromFirestore).toList())
        .handleError((e) {
          throw FirebaseException(plugin: 'firestore', message: e.toString());
        });
  }

  // Fetches tasks once without streaming.
  Future<List<Task>> fetchTasksOnce() async {
    final snap = await _tasks.orderBy('dueDate', descending: false).get();
    return snap.docs.map(Task.fromFirestore).toList();
  }

  // Adds a new task.
  Future<void> addTask(Task task) async {
    try {
      await _tasks.add(task.toFirestore());
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  // Updates an existing task.
  Future<void> updateTask(Task task) async {
    try {
      await _tasks.doc(task.id).update(task.toFirestore());
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // Updates task status.
  Future<void> updateStatus(String id, String status) async {
    try {
      await _tasks.doc(id).update({
        'status': status,
        'isCompleted': status == 'completed',
      });
    } catch (e) {
      throw Exception('Failed to update status: $e');
    }
  }

  // Deletes a task.
  Future<void> deleteTask(String id) async {
    try {
      await _tasks.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // Toggles task completion status.
  Future<void> toggleCompletion(String id, bool currentCompleted) async {
    try {
      final next = !currentCompleted;
      await _tasks.doc(id).update({
        'isCompleted': next,
        'status': next ? 'completed' : 'todo',
      });
    } catch (e) {
      throw Exception('Failed to toggle completion: $e');
    }
  }
}