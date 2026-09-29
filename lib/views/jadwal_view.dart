import 'package:flutter/material.dart';
import '../models/schedule_model.dart';

class JadwalView extends StatelessWidget {
  final List<ScheduleItem> schedules;
  final void Function() onAdd;
  final void Function(ScheduleItem item) onEdit;
  final void Function(ScheduleItem item) onDelete;

  const JadwalView({
    super.key,
    required this.schedules,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // kelompokkan berdasarkan hari, urut sesuai kHariList
    final Map<String, List<ScheduleItem>> grouped = {
      for (final h in kHariList)
        h: schedules.where((s) => s.hari == h).toList(),
    };

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${schedules.length} jadwal kuliah",
                style: const TextStyle(color: Colors.white70),
              ),
              ElevatedButton.icon(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Tambah Jadwal"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: schedules.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada jadwal kuliah.\nTekan \"Tambah Jadwal\" untuk menambah.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white38),
                    ),
                  )
                : ListView(
                    children: kHariList
                        .where((h) => grouped[h]!.isNotEmpty)
                        .map(
                          (h) => _DaySection(
                            hari: h,
                            items: grouped[h]!,
                            onEdit: onEdit,
                            onDelete: onDelete,
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  final String hari;
  final List<ScheduleItem> items;
  final void Function(ScheduleItem item) onEdit;
  final void Function(ScheduleItem item) onDelete;

  const _DaySection({
    required this.hari,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            hari,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        ...items.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF141A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.matkul,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.jamRange,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white38,
                    size: 20,
                  ),
                  onPressed: () => onEdit(item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white38),
                  onPressed: () => onDelete(item),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
