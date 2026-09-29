import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final bool done;
  final String category;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TaskCard({
    super.key,
    required this.title,
    required this.done,
    this.category = 'Umum',
    this.onToggle,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = TaskCategory.byLabel(category).color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF141A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Icon(
              done ? Icons.check_circle : Icons.access_time_rounded,
              color: done ? Colors.greenAccent : Colors.orangeAccent,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: GestureDetector(
              onTap: onEdit,
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: catColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: catColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: catColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white38,
              size: 20,
            ),
            onPressed: onEdit,
            tooltip: 'Edit tugas',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white38),
            onPressed: onDelete,
            tooltip: 'Hapus tugas',
          ),
        ],
      ),
    );
  }
}
