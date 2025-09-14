import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// This class represents a Task model with immutable properties.
// It includes factory constructor for Firestore deserialization and methods for serialization and copying.
@immutable
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final bool isCompleted;
  final String status;
  final String priority;
  final String category;

  // Constructor with default values for optional fields.
  const Task({
    this.id = '',
    required this.title,
    this.description = '',
    this.dueDate,
    this.isCompleted = false,
    this.status = 'todo',
    this.priority = 'Med',
    this.category = 'General',
  });

  // Factory constructor to create Task from Firestore document.
  // Handles legacy 'isCompleted' field and maps status accordingly.
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
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
      category: data['category'] as String? ?? 'General',
    );
  }

  // Converts Task to Firestore-compatible map.
  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'isCompleted': status == 'completed',
        'status': status,
        'priority': priority,
        'category': category,
      };

  // Creates a copy of the Task with optional overrides.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    String? status,
    String? priority,
    String? category,
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
      category: category ?? this.category,
    );
  }
}