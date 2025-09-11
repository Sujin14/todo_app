import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskRepository {
  final String userId;
  TaskRepository({required this.userId});

  CollectionReference<Map<String, dynamic>> get _tasks => FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .collection('tasks');

  Stream<List<Task>> getTasks() {
    return _tasks
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Task.fromFirestore).toList())
        .handleError((e) {
          throw FirebaseException(plugin: 'firestore', message: e.toString());
        });
  }

  Future<List<Task>> fetchTasksOnce() async {
    final snap = await _tasks.orderBy('dueDate', descending: false).get();
    return snap.docs.map(Task.fromFirestore).toList();
  }

  Future<void> addTask(Task task) async {
    try {
      await _tasks.add(task.toFirestore());
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _tasks.doc(task.id).update(task.toFirestore());
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

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

  Future<void> deleteTask(String id) async {
    try {
      await _tasks.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

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