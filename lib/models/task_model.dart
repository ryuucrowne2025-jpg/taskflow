import 'package:flutter/material.dart';

/// Kategori tugas yang tersedia beserta warnanya masing-masing.
class TaskCategory {
  final String label;
  final Color color;
  final IconData icon;

  const TaskCategory(this.label, this.color, this.icon);

  static const List<TaskCategory> all = [
    TaskCategory('Umum', Color(0xFF818CF8), Icons.folder_open_rounded),
    TaskCategory('Kuliah', Color(0xFF34D399), Icons.school_rounded),
    TaskCategory('Kerja', Color(0xFFF59E0B), Icons.work_outline_rounded),
    TaskCategory('Pribadi', Color(0xFFF43F5E), Icons.person_outline_rounded),
  ];

  static TaskCategory byLabel(String label) {
    return all.firstWhere((c) => c.label == label, orElse: () => all.first);
  }
}

/// Tingkat prioritas tugas dengan bobot XP gamifikasi
enum TaskPriority {
  tinggi('Tinggi', Color(0xFFEF4444), 100, Icons.keyboard_double_arrow_up_rounded),
  sedang('Sedang', Color(0xFFF59E0B), 50, Icons.drag_handle_rounded),
  rendah('Rendah', Color(0xFF10B981), 25, Icons.keyboard_double_arrow_down_rounded);

  final String label;
  final Color color;
  final int xp;
  final IconData icon;

  const TaskPriority(this.label, this.color, this.xp, this.icon);

  static TaskPriority byLabel(String label) {
    return TaskPriority.values.firstWhere(
      (p) => p.label.toLowerCase() == label.toLowerCase(),
      orElse: () => TaskPriority.sedang,
    );
  }
}

class Task {
  String id;
  String title;
  bool done;
  String category;
  TaskPriority priority;
  DateTime? deadline;

  /// dipakai internal biar reminder yang sama tidak muncul berulang-ulang
  bool reminderShown;

  Task({
    required this.id,
    required this.title,
    this.done = false,
    this.category = 'Umum',
    this.priority = TaskPriority.sedang,
    this.deadline,
    this.reminderShown = false,
  });

  /// XP reward ketika tugas diselesaikan
  int get calculatedXp {
    int total = priority.xp;
    // Early Bird bonus jika diselesaikan sebelum deadline
    if (deadline != null && DateTime.now().isBefore(deadline!)) {
      total += 25; // Bonus selesai tepat waktu
    }
    return total;
  }

  /// true kalau deadline sudah lewat dan tugas belum selesai
  bool get isOverdue =>
      deadline != null && !done && deadline!.isBefore(DateTime.now());

  /// true kalau deadline kurang dari [window] lagi dan tugas belum selesai
  bool isDueSoon(Duration window) {
    if (deadline == null || done) return false;
    final now = DateTime.now();
    return deadline!.isAfter(now) && deadline!.difference(now) <= window;
  }
}

/// Alias kompatibilitas
typedef TaskModel = Task;
