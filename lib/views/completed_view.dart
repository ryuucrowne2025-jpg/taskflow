import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';

class CompletedView extends StatelessWidget {
  final List<Task> tasks; // already filtered to done == true
  final void Function(Task task) onToggle;
  final void Function(Task task) onDelete;
  final void Function(Task task) onEdit;

  const CompletedView({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Total XP earned from all completed tasks
    final totalEarnedXp =
        tasks.fold<int>(0, (sum, t) => sum + t.calculatedXp);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner XP dari tugas selesai
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF064E3B), Color(0xFF065F46)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.verified_rounded,
                  color: Color(0xFF34D399),
                  size: 28,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${tasks.length} Tugas Telah Selesai",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Kamu telah mengumpulkan +$totalEarnedXp XP dari pencapaian ini!",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 52,
                          color: Colors.white.withOpacity(0.15),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Belum ada tugas yang selesai.\nTandai tugas di halaman Tasks sebagai selesai untuk meraih XP!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (ctx, i) {
                      final task = tasks[i];
                      return TaskCard(
                        title: task.title,
                        done: task.done,
                        category: task.category,
                        priority: task.priority,
                        deadline: task.deadline,
                        onToggle: () => onToggle(task),
                        onDelete: () => onDelete(task),
                        onEdit: () => onEdit(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
