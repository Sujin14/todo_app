import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

class TaskRepository {
  final String userId;

  TaskRepository({required this.userId});

  CollectionReference<Map<String, dynamic>> get _tasks => FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .collection('tasks'); // Fetching data from the Firestore

  Stream<List<Task>> getTasks() {
    return _tasks
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Task.fromFirestore).toList())
        .handleError(
          (e) => throw FirebaseException(
            plugin: 'firestore',
            message: e.toString(),
          ),
        );
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

  Future<void> deleteTask(String id) async {
    try {
      await _tasks.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Future<void> toggleCompletion(String id, bool currentCompleted) async {
    try {
      await _tasks.doc(id).update({'isCompleted': !currentCompleted});
    } catch (e) {
      throw Exception('Failed to toggle completion: $e');
    }
  }
}
