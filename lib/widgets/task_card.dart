import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../reminder_service.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final bool done;
  final String category;
  final TaskPriority priority;
  final DateTime? deadline;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TaskCard({
    super.key,
    required this.title,
    required this.done,
    this.category = 'Umum',
    this.priority = TaskPriority.sedang,
    this.deadline,
    this.onToggle,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final cat = TaskCategory.byLabel(category);
    final catColor = cat.color;

    final bool overdue =
        !done && deadline != null && deadline!.isBefore(DateTime.now());
    final bool dueSoon =
        !done &&
        deadline != null &&
        !overdue &&
        deadline!.difference(DateTime.now()) <= kReminderWindow;

    Color deadlineColor = Colors.white54;
    if (overdue) deadlineColor = const Color(0xFFEF4444);
    if (dueSoon) deadlineColor = const Color(0xFFF59E0B);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF141A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: overdue
              ? const Color(0xFFEF4444).withOpacity(0.5)
              : done
                  ? const Color(0xFF10B981).withOpacity(0.2)
                  : Colors.white.withOpacity(0.06),
          width: overdue ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // 🔥 CHECKBOX INTERACTIVE WITH XP FEEDBACK
                GestureDetector(
                  onTap: onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done
                          ? const Color(0xFF10B981)
                          : Colors.white.withOpacity(0.05),
                      border: Border.all(
                        color: done
                            ? const Color(0xFF10B981)
                            : Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: done
                          ? [
                              BoxShadow(
                                color: const Color(0xFF10B981).withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: done
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 17,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 14),
                // 🔥 TASK DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: done ? Colors.white38 : Colors.white,
                          fontSize: 15,
                          fontWeight:
                              done ? FontWeight.normal : FontWeight.w600,
                          decoration: done ? TextDecoration.lineThrough : null,
                          decorationColor: Colors.white38,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          // 🏷️ Kategori
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: catColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: catColor.withOpacity(0.35),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(cat.icon, size: 11, color: catColor),
                                const SizedBox(width: 4),
                                Text(
                                  category,
                                  style: TextStyle(
                                    color: catColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ⚡ Prioritas Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: priority.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: priority.color.withOpacity(0.35),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  priority.icon,
                                  size: 12,
                                  color: priority.color,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  priority.label,
                                  style: TextStyle(
                                    color: priority.color,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 🎮 XP Reward Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBBF24).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.bolt_rounded,
                                  size: 12,
                                  color: Color(0xFFFBBF24),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  "+${priority.xp} XP",
                                  style: const TextStyle(
                                    color: Color(0xFFFBBF24),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ⏰ Deadline Badge
                          if (deadline != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: deadlineColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: deadlineColor.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.alarm_rounded,
                                    size: 12,
                                    color: deadlineColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${formatDeadline(deadline!)} • ${timeUntil(deadline!)}",
                                    style: TextStyle(
                                      color: deadlineColor,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ⚙️ Action Buttons
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white38,
                    size: 19,
                  ),
                  onPressed: onEdit,
                  tooltip: 'Edit tugas',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white38,
                    size: 19,
                  ),
                  onPressed: onDelete,
                  tooltip: 'Hapus tugas',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
