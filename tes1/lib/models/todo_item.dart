import 'package:flutter/material.dart';

class TodoItem {
  String title;
  String description;
  DateTime? deadline;
  String category;
  IconData icon;
  bool isCompleted;
  DateTime? completedAt;

  bool isRoutine;
  List<int> routineDays;
  TimeOfDay? routineTime;

  bool isFavorite;
  bool isImportant;
  bool isIgnored;

  bool notified1Hour;
  bool notified5Min;

  TodoItem({
    required this.title,
    required this.description,
    this.deadline,
    required this.category,
    required this.icon,
    this.isCompleted = false,
    this.completedAt,
    this.isRoutine = false,
    this.routineDays = const [],
    this.routineTime,
    this.isFavorite = false,
    this.isImportant = false,
    this.isIgnored = false,
    this.notified1Hour = false,
    this.notified5Min = false,
  });

  bool get isOverdue {
    if (isRoutine) return false;
    if (deadline == null || isCompleted || isIgnored) return false;
    return DateTime.now().isAfter(deadline!);
  }
}