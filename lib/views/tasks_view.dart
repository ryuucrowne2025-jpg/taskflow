import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';

class TasksView extends StatefulWidget {
  final List<Task> tasks;
  final void Function(Task task) onToggle;
  final void Function(Task task) onDelete;
  final void Function(Task task) onEdit;

  const TasksView({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  String selectedFilter = 'Semua';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.tasks.where((t) {
      final matchesCat =
          selectedFilter == 'Semua' || t.category == selectedFilter;
      final matchesSearch =
          t.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.tasks.length} total tugas",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "${widget.tasks.where((t) => !t.done).length} aktif",
                style: const TextStyle(
                  color: Color(0xFFF59E0B),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Search bar
          TextField(
            onChanged: (v) => setState(() => searchQuery = v),
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

          const SizedBox(height: 12),

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

          const SizedBox(height: 16),

          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: 48,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Belum ada tugas pada kategori ini.\nTekan tombol + untuk menambah.",
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
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final task = filtered[i];
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
}
