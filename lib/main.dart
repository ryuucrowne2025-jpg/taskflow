import 'dart:async';
import 'package:flutter/material.dart';
import 'models/task_model.dart';
import 'models/schedule_model.dart';
import 'models/gamification_model.dart';
import 'reminder_service.dart';
import 'views/completed_view.dart';
import 'views/home_view.dart';
import 'views/login_view.dart';
import 'views/tasks_view.dart';
import 'views/jadwal_view.dart';
import 'views/gamification_view.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B132B),
        primaryColor: const Color(0xFF6366F1),
        fontFamily: 'Poppins',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const LoginView(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;
  Timer? _reminderTimer;

  // 🎮 GAMIFICATION MANAGER
  final GamificationManager gamification = GamificationManager();

  // 🔥 STATE TUGAS
  final List<Task> tasks = [
    Task(
      id: '1',
      title: 'Design UI TaskFlow Pro',
      done: true,
      category: 'Kerja',
      priority: TaskPriority.tinggi,
    ),
    Task(
      id: '2',
      title: 'Build Flutter APK & Gamifikasi',
      done: false,
      category: 'Kuliah',
      priority: TaskPriority.tinggi,
      deadline: DateTime.now().add(const Duration(hours: 4)),
    ),
    Task(
      id: '3',
      title: 'Review Requirement PKPL',
      done: false,
      category: 'Kuliah',
      priority: TaskPriority.sedang,
      deadline: DateTime.now().add(const Duration(minutes: 45)),
    ),
  ];

  // 🔥 STATE JADWAL KULIAH
  final List<ScheduleItem> schedules = [
    ScheduleItem(
      id: 's1',
      matkul: 'Penjaminan Kualitas Perangkat Lunak',
      hari: 'Rabu',
      jamMulai: const TimeOfDay(hour: 8, minute: 0),
      jamSelesai: const TimeOfDay(hour: 10, minute: 30),
    ),
    ScheduleItem(
      id: 's2',
      matkul: 'Rekayasa Perangkat Lunak',
      hari: 'Senin',
      jamMulai: const TimeOfDay(hour: 10, minute: 0),
      jamSelesai: const TimeOfDay(hour: 12, minute: 30),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Pengecekan berkala deadline notifikasi
    _reminderTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _reminderTimer?.cancel();
    super.dispose();
  }

  // ================== TUGAS & GAMIFIKASI ACTION ==================
  void addTask(
    String title,
    String category,
    TaskPriority priority,
    DateTime? deadline,
  ) {
    if (title.trim().isEmpty) return;
    setState(() {
      tasks.add(
        Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title.trim(),
          category: category,
          priority: priority,
          deadline: deadline,
        ),
      );
    });
  }

  void editTask(
    Task task,
    String newTitle,
    String newCategory,
    TaskPriority newPriority,
    DateTime? newDeadline,
  ) {
    if (newTitle.trim().isEmpty) return;
    setState(() {
      task.title = newTitle.trim();
      task.category = newCategory;
      task.priority = newPriority;
      task.deadline = newDeadline;
    });
  }

  void deleteTask(Task task) {
    setState(() => tasks.remove(task));
  }

  void toggleTask(Task task) {
    setState(() {
      task.done = !task.done;

      if (task.done) {
        // Beri reward XP
        final earnedXp = task.calculatedXp;
        final leveledUp = gamification.addXp(earnedXp);

        // Periksa unlock badge
        final completedHigh =
            task.priority == TaskPriority.tinggi;
        final newBadges = gamification.checkBadges(
          completedCount: tasks.where((t) => t.done).length,
          completedHighPriority: completedHigh,
          scheduleCount: schedules.length,
        );

        // Feedback Snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF1E1B4B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF6366F1)),
            ),
            content: Row(
              children: [
                const Icon(
                  Icons.stars_rounded,
                  color: Color(0xFFFBBF24),
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Tugas Selesai! Kamu meraih +$earnedXp XP!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        // Jika naik level, tampilkan modal selebrasi
        if (leveledUp) {
          _showLevelUpDialog();
        } else if (newBadges.isNotEmpty) {
          _showBadgeUnlockedDialog(newBadges.first);
        }
      }
    });
  }

  void _showLevelUpDialog() {
    final level = gamification.currentLevelInfo;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B4B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: level.color, width: 2),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [level.color, const Color(0xFF8B5CF6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: level.color.withOpacity(0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.military_tech_rounded,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "🎉 LEVEL UP! 🎉",
              style: TextStyle(
                color: Color(0xFFFBBF24),
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Kamu berhasil naik ke Level ${level.level}!",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Gelar Baru: \"${level.title}\"",
              style: TextStyle(
                color: level.color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: level.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                "Lanjutkan Belajar!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeUnlockedDialog(BadgeItem badge) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: badge.color),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badge.color.withOpacity(0.2),
              ),
              child: Icon(badge.icon, size: 40, color: badge.color),
            ),
            const SizedBox(height: 14),
            const Text(
              "🎖️ Medali Baru Terbuka!",
              style: TextStyle(
                color: Color(0xFFFBBF24),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              badge.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Keren!"),
            ),
          ],
        ),
      ),
    );
  }

  // ================== JADWAL ==================
  void addSchedule(
    String matkul,
    String hari,
    TimeOfDay mulai,
    TimeOfDay selesai,
  ) {
    if (matkul.trim().isEmpty) return;
    setState(() {
      schedules.add(
        ScheduleItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          matkul: matkul.trim(),
          hari: hari,
          jamMulai: mulai,
          jamSelesai: selesai,
        ),
      );
      gamification.checkBadges(
        completedCount: tasks.where((t) => t.done).length,
        completedHighPriority: false,
        scheduleCount: schedules.length,
      );
    });
  }

  void editSchedule(
    ScheduleItem item,
    String matkul,
    String hari,
    TimeOfDay mulai,
    TimeOfDay selesai,
  ) {
    if (matkul.trim().isEmpty) return;
    setState(() {
      item.matkul = matkul.trim();
      item.hari = hari;
      item.jamMulai = mulai;
      item.jamSelesai = selesai;
    });
  }

  void deleteSchedule(ScheduleItem item) {
    setState(() => schedules.remove(item));
  }

  // ================== LOGOUT ==================
  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  // ================== KONFIRMASI HAPUS ==================
  void _confirmDelete({
    required String itemLabel,
    required VoidCallback onConfirmed,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C2541),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 22,
            ),
            SizedBox(width: 8),
            Text("Konfirmasi Hapus", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Text(
          "Yakin akan menghapus \"$itemLabel\"?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              onConfirmed();
              Navigator.pop(ctx);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTask(Task task) {
    _confirmDelete(itemLabel: task.title, onConfirmed: () => deleteTask(task));
  }

  void _confirmDeleteSchedule(ScheduleItem item) {
    _confirmDelete(
      itemLabel: item.matkul,
      onConfirmed: () => deleteSchedule(item),
    );
  }

  // ================== DIALOG TUGAS PRO (DENGAN PRIORITAS & XP) ==================
  void _showTaskDialog({Task? existingTask}) {
    final isEdit = existingTask != null;
    final controller = TextEditingController(text: existingTask?.title ?? '');
    String selectedCategory =
        existingTask?.category ?? TaskCategory.all.first.label;
    TaskPriority selectedPriority =
        existingTask?.priority ?? TaskPriority.sedang;
    DateTime? selectedDeadline = existingTask?.deadline;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF141A2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white.withOpacity(0.08)),
              ),
              title: Text(
                isEdit ? "Edit Tugas" : "Tugas Baru",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: controller,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Nama / judul tugas",
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kategori
                    const Text(
                      "Kategori",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: TaskCategory.all.map((cat) {
                        final isSelected = selectedCategory == cat.label;
                        return GestureDetector(
                          onTap: () => setDialogState(
                            () => selectedCategory = cat.label,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? cat.color.withOpacity(0.25)
                                  : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? cat.color : Colors.white12,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  cat.icon,
                                  size: 13,
                                  color: isSelected ? cat.color : Colors.white60,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  cat.label,
                                  style: TextStyle(
                                    color: isSelected
                                        ? cat.color
                                        : Colors.white70,
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Prioritas & XP Bobot
                    const Text(
                      "Tingkat Prioritas (Reward XP)",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: TaskPriority.values.map((p) {
                        final isSel = selectedPriority == p;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setDialogState(
                              () => selectedPriority = p,
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel
                                    ? p.color.withOpacity(0.25)
                                    : Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSel ? p.color : Colors.white12,
                                  width: isSel ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    p.label,
                                    style: TextStyle(
                                      color: isSel ? p.color : Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "+${p.xp} XP",
                                    style: TextStyle(
                                      color: isSel
                                          ? const Color(0xFFFBBF24)
                                          : Colors.white38,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Deadline Picker
                    const Text(
                      "Deadline (opsional)",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white70,
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            icon: const Icon(Icons.event, size: 16),
                            label: Text(
                              selectedDeadline == null
                                  ? "Pilih tanggal & jam"
                                  : formatDeadline(selectedDeadline!),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onPressed: () async {
                              final now = DateTime.now();
                              final date = await showDatePicker(
                                context: ctx,
                                initialDate: selectedDeadline ?? now,
                                firstDate: DateTime(now.year - 1),
                                lastDate: DateTime(now.year + 3),
                              );
                              if (date == null) return;
                              if (!ctx.mounted) return;
                              final time = await showTimePicker(
                                context: ctx,
                                initialTime: TimeOfDay.fromDateTime(
                                  selectedDeadline ?? now,
                                ),
                              );
                              if (time == null) return;
                              setDialogState(() {
                                selectedDeadline = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            },
                          ),
                        ),
                        if (selectedDeadline != null)
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.white38,
                              size: 18,
                            ),
                            onPressed: () => setDialogState(
                              () => selectedDeadline = null,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Batal", style: TextStyle(color: Colors.white60)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (isEdit) {
                      editTask(
                        existingTask,
                        controller.text,
                        selectedCategory,
                        selectedPriority,
                        selectedDeadline,
                      );
                    } else {
                      addTask(
                        controller.text,
                        selectedCategory,
                        selectedPriority,
                        selectedDeadline,
                      );
                    }
                    Navigator.pop(ctx);
                  },
                  child: Text(isEdit ? "Simpan" : "Tambah"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ================== DIALOG JADWAL ==================
  void _showScheduleDialog({ScheduleItem? existingItem}) {
    final isEdit = existingItem != null;
    final matkulController = TextEditingController(
      text: existingItem?.matkul ?? '',
    );
    String selectedHari = existingItem?.hari ?? kHariList.first;
    TimeOfDay jamMulai =
        existingItem?.jamMulai ?? const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay jamSelesai =
        existingItem?.jamSelesai ?? const TimeOfDay(hour: 10, minute: 0);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF141A2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                isEdit ? "Edit Jadwal" : "Tambah Jadwal",
                style: const TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: matkulController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Nama mata kuliah",
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Hari",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kHariList.map((h) {
                        final isSelected = selectedHari == h;
                        return GestureDetector(
                          onTap: () => setDialogState(() => selectedHari = h),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF6366F1).withOpacity(0.25)
                                  : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF6366F1)
                                    : Colors.white24,
                              ),
                            ),
                            child: Text(
                              h,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF818CF8)
                                    : Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white70,
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            onPressed: () async {
                              final t = await showTimePicker(
                                context: ctx,
                                initialTime: jamMulai,
                              );
                              if (t != null) setDialogState(() => jamMulai = t);
                            },
                            child: Text("Mulai: ${jamMulai.format(ctx)}"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white70,
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            onPressed: () async {
                              final t = await showTimePicker(
                                context: ctx,
                                initialTime: jamSelesai,
                              );
                              if (t != null)
                                setDialogState(() => jamSelesai = t);
                            },
                            child: Text("Selesai: ${jamSelesai.format(ctx)}"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Batal", style: TextStyle(color: Colors.white60)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                  ),
                  onPressed: () {
                    if (isEdit) {
                      editSchedule(
                        existingItem,
                        matkulController.text,
                        selectedHari,
                        jamMulai,
                        jamSelesai,
                      );
                    } else {
                      addSchedule(
                        matkulController.text,
                        selectedHari,
                        jamMulai,
                        jamSelesai,
                      );
                    }
                    Navigator.pop(ctx);
                  },
                  child: Text(isEdit ? "Simpan" : "Tambah"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ================== PANEL NOTIFIKASI ==================
  void _showReminderPanel(List<ReminderInfo> reminders) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.notifications_active_rounded, color: Colors.orangeAccent, size: 20),
            SizedBox(width: 8),
            Text("Pengingat Tenggat Waktu", style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        content: SizedBox(
          width: 320,
          child: reminders.isEmpty
              ? const Text(
                  "Tidak ada tugas yang mendekati deadline.",
                  style: TextStyle(color: Colors.white38),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: reminders.map((r) {
                    final color = r.overdue
                        ? const Color(0xFFEF4444)
                        : const Color(0xFFF59E0B);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            r.overdue ? Icons.error_outline_rounded : Icons.alarm_rounded,
                            color: color,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.task.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${formatDeadline(r.task.deadline!)} • ${timeUntil(r.task.deadline!)}",
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Tutup", style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks.where((t) => t.done).toList();
    final reminders = collectReminders(tasks);

    final List<Widget> pages = [
      HomeView(
        tasks: tasks,
        gamification: gamification,
        onToggle: toggleTask,
        onDelete: _confirmDeleteTask,
        onEdit: (task) => _showTaskDialog(existingTask: task),
        onOpenGamification: () => setState(() => selectedIndex = 3),
      ),
      TasksView(
        tasks: tasks,
        onToggle: toggleTask,
        onDelete: _confirmDeleteTask,
        onEdit: (task) => _showTaskDialog(existingTask: task),
      ),
      JadwalView(
        schedules: schedules,
        onAdd: () => _showScheduleDialog(),
        onEdit: (item) => _showScheduleDialog(existingItem: item),
        onDelete: _confirmDeleteSchedule,
      ),
      GamificationView(
        gamification: gamification,
        completedTasksCount: completedTasks.length,
        totalTasksCount: tasks.length,
      ),
      CompletedView(
        tasks: completedTasks,
        onToggle: toggleTask,
        onDelete: _confirmDeleteTask,
        onEdit: (task) => _showTaskDialog(existingTask: task),
      ),
    ];

    final titles = ["Dashboard", "Tasks", "Jadwal", "Pencapaian & XP", "Completed"];

    return Scaffold(
      body: Row(
        children: [
          // 🔥 PRO SIDEBAR NAVIGATION
          Container(
            width: 230,
            color: const Color(0xFF141A2A),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo & App Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "TaskFlow",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                sidebarItem("Dashboard", Icons.dashboard_rounded, 0),
                sidebarItem("Tasks", Icons.task_alt_rounded, 1),
                sidebarItem("Jadwal", Icons.calendar_month_rounded, 2),
                sidebarItem("Pencapaian", Icons.emoji_events_rounded, 3, badgeText: "Lv.${gamification.currentLevel}"),
                sidebarItem("Completed", Icons.check_circle_rounded, 4),

                const Spacer(),

                // User Profile & Streak Box
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFF6366F1),
                        child: const Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Fajri Ahmad",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${gamification.xp} XP",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFFFBBF24),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Logout Button
                InkWell(
                  onTap: _logout,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
                        SizedBox(width: 10),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔥 MAIN CONTENT
          Expanded(
            child: Scaffold(
              backgroundColor: const Color(0xFF0B132B),
              appBar: AppBar(
                title: Text(
                  titles[selectedIndex],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                actions: [
                  // Lonceng Notifikasi
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none_rounded),
                          onPressed: () => _showReminderPanel(reminders),
                          tooltip: 'Pengingat',
                        ),
                        if (reminders.isNotEmpty)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                "${reminders.length}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              body: pages[selectedIndex],
              floatingActionButton: (selectedIndex == 2 || selectedIndex == 3)
                  ? null
                  : Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: FloatingActionButton(
                        onPressed: () => _showTaskDialog(),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        child: const Icon(Icons.add_rounded, size: 28),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sidebarItem(
    String title,
    IconData icon,
    int index, {
    String? badgeText,
  }) {
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => setState(() => selectedIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF6366F1).withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: const Color(0xFF6366F1).withOpacity(0.4))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF818CF8) : Colors.white60,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (badgeText != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    color: Color(0xFF818CF8),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
