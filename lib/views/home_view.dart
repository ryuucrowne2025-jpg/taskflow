import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/gamification_model.dart';
import '../widgets/task_card.dart';

class HomeView extends StatefulWidget {
  final List<Task> tasks;
  final GamificationManager gamification;
  final void Function(Task task) onToggle;
  final void Function(Task task) onDelete;
  final void Function(Task task) onEdit;
  final VoidCallback onOpenGamification;

  const HomeView({
    super.key,
    required this.tasks,
    required this.gamification,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    required this.onOpenGamification,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String selectedFilter = 'Semua';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final total = widget.tasks.length;
    final done = widget.tasks.where((t) => t.done).length;
    final pending = total - done;

    // Filter list
    final filteredTasks = widget.tasks.where((t) {
      final matchesCategory =
          selectedFilter == 'Semua' || t.category == selectedFilter;
      final matchesSearch =
          t.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    final level = widget.gamification.currentLevelInfo;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏆 PRO GAMIFICATION BANNER (QUICK LEVEL & STREAK)
          InkWell(
            onTap: widget.onOpenGamification,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF2E1065)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF818CF8).withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [level.color, const Color(0xFF6366F1)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Lv.${level.level}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              level.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department_rounded,
                                    color: Colors.orangeAccent,
                                    size: 13,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    "${widget.gamification.streak} Hari",
                                    style: const TextStyle(
                                      color: Colors.orangeAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: widget.gamification.levelProgress,
                            minHeight: 6,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              level.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white38,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 📊 STAT CARDS (Pro Modern Gradients)
          Row(
            children: [
              statCard(
                title: "Total",
                value: "$total",
                subtitle: "Tugas dibuat",
                icon: Icons.assignment_outlined,
                gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              ),
              const SizedBox(width: 12),
              statCard(
                title: "Selesai",
                value: "$done",
                subtitle: total > 0
                    ? "${((done / total) * 100).toInt()}% tercapai"
                    : "0%",
                icon: Icons.check_circle_outline_rounded,
                gradient: const [Color(0xFF10B981), Color(0xFF047857)],
              ),
              const SizedBox(width: 12),
              statCard(
                title: "Pending",
                value: "$pending",
                subtitle: "Perlu dikerjakan",
                icon: Icons.hourglass_top_rounded,
                gradient: const [Color(0xFFF59E0B), Color(0xFFB45309)],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 🔍 SEARCH BAR & CATEGORY FILTERS
          TextField(
            onChanged: (val) => setState(() => searchQuery = val),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: "Cari tugas...",
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF141A2A),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Semua'),
                ...TaskCategory.all.map((c) => _buildFilterChip(c.label)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 📝 TASK LIST
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Daftar Tugas (${filteredTasks.length})",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (filteredTasks.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(
                    Icons.task_alt_rounded,
                    size: 48,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    searchQuery.isNotEmpty
                        ? "Tidak ada tugas dengan kata kunci \"$searchQuery\""
                        : "Tidak ada tugas pada filter ini",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredTasks.length,
              itemBuilder: (ctx, i) {
                final task = filteredTasks[i];
                return TaskCard(
                  title: task.title,
                  done: task.done,
                  category: task.category,
                  priority: task.priority,
                  deadline: task.deadline,
                  onToggle: () => widget.onToggle(task),
                  onDelete: () => widget.onDelete(task),
                  onEdit: () => widget.onEdit(task),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => selectedFilter = label),
        backgroundColor: const Color(0xFF141A2A),
        selectedColor: const Color(0xFF4F46E5),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.white60,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? const Color(0xFF6366F1)
                : Colors.white.withOpacity(0.06),
          ),
        ),
      ),
    );
  }

  Widget statCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(icon, color: Colors.white70, size: 16),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
