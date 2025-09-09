import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  /// Backward-compat flag; still written for older docs.
  final bool isCompleted;
  /// New normalized status: 'todo' | 'pending' | 'completed'
  final String status;
  final String priority;

  const Task({
    this.id = '',
    required this.title,
    this.description = '',
    this.dueDate,
    this.isCompleted = false,
    this.status = 'todo',
    this.priority = 'Med',
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    // Prefer 'status'; fallback to old 'isCompleted'
    final rawStatus = (data['status'] as String?)?.toLowerCase();
    final bool legacyCompleted = data['isCompleted'] as bool? ?? false;
    final status = switch (rawStatus) {
      'pending' => 'pending',
      'completed' => 'completed',
      'todo' => 'todo',
      _ => legacyCompleted ? 'completed' : 'todo',
    };
    return Task(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      isCompleted: data['isCompleted'] as bool? ?? (status == 'completed'),
      status: status,
      priority: data['priority'] as String? ?? 'Med',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'dueDate': dueDate,
        // Keep legacy field updated; write the normalized status too.
        'isCompleted': status == 'completed',
        'status': status,
        'priority': priority,
      };

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    String? status,
    String? priority,
  }) {
    final nextStatus = status ?? this.status;
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? (nextStatus == 'completed'),
      status: nextStatus,
      priority: priority ?? this.priority,
    );
  }
}
