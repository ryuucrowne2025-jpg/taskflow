import 'package:flutter/material.dart';

class BadgeItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int xpReward;
  bool isUnlocked;

  BadgeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.xpReward,
    this.isUnlocked = false,
  });
}

class LevelInfo {
  final int level;
  final String title;
  final int minXp;
  final int maxXp;
  final Color color;

  const LevelInfo({
    required this.level,
    required this.title,
    required this.minXp,
    required this.maxXp,
    required this.color,
  });
}

class GamificationManager {
  static const List<LevelInfo> levels = [
    LevelInfo(
      level: 1,
      title: 'Novice Scholar',
      minXp: 0,
      maxXp: 150,
      color: Color(0xFF60A5FA), // Blue
    ),
    LevelInfo(
      level: 2,
      title: 'Task Apprentice',
      minXp: 151,
      maxXp: 350,
      color: Color(0xFF34D399), // Emerald
    ),
    LevelInfo(
      level: 3,
      title: 'Productivity Adept',
      minXp: 351,
      maxXp: 650,
      color: Color(0xFFFBBF24), // Amber
    ),
    LevelInfo(
      level: 4,
      title: 'Task Master',
      minXp: 651,
      maxXp: 1050,
      color: Color(0xFFA855F7), // Purple
    ),
    LevelInfo(
      level: 5,
      title: 'Grandmaster Achiever',
      minXp: 1051,
      maxXp: 2000,
      color: Color(0xFFF43F5E), // Rose / Crimson
    ),
  ];

  int xp = 120;
  int streak = 3; // 3 hari beruntun

  late List<BadgeItem> badges;

  GamificationManager() {
    badges = [
      BadgeItem(
        id: 'first_task',
        title: 'Langkah Pertama',
        description: 'Selesaikan tugas pertamamu',
        icon: Icons.flag_rounded,
        color: const Color(0xFF60A5FA),
        xpReward: 50,
        isUnlocked: true,
      ),
      BadgeItem(
        id: 'high_priority',
        title: 'Pemburu Prioritas',
        description: 'Selesaikan tugas berprioritas Tinggi',
        icon: Icons.local_fire_department_rounded,
        color: const Color(0xFFEF4444),
        xpReward: 75,
        isUnlocked: false,
      ),
      BadgeItem(
        id: 'anti_deadline',
        title: 'Anti Deadline',
        description: 'Selesaikan tugas sebelum mendekati batas waktu',
        icon: Icons.shield_rounded,
        color: const Color(0xFF10B981),
        xpReward: 100,
        isUnlocked: false,
      ),
      BadgeItem(
        id: 'streak_3',
        title: 'Semangat Menyala',
        description: 'Pertahankan produktivitas selama 3 hari beruntun',
        icon: Icons.whatshot_rounded,
        color: const Color(0xFFF59E0B),
        xpReward: 150,
        isUnlocked: true,
      ),
      BadgeItem(
        id: 'scheduler',
        title: 'Arsitek Jadwal',
        description: 'Tambahkan minimal 2 jadwal kuliah',
        icon: Icons.calendar_month_rounded,
        color: const Color(0xFF8B5CF6),
        xpReward: 100,
        isUnlocked: false,
      ),
      BadgeItem(
        id: 'five_tasks',
        title: 'Produktif Maksimal',
        description: 'Selesaikan akumulasi 5 tugas',
        icon: Icons.military_tech_rounded,
        color: const Color(0xFFEC4899),
        xpReward: 200,
        isUnlocked: false,
      ),
    ];
  }

  LevelInfo get currentLevelInfo {
    for (final l in levels) {
      if (xp <= l.maxXp) return l;
    }
    return levels.last;
  }

  int get currentLevel => currentLevelInfo.level;

  double get levelProgress {
    final info = currentLevelInfo;
    final range = info.maxXp - info.minXp;
    if (range <= 0) return 1.0;
    final currentInRange = (xp - info.minXp).clamp(0, range);
    return currentInRange / range;
  }

  int get xpToNextLevel {
    final info = currentLevelInfo;
    return (info.maxXp - xp).clamp(0, 9999);
  }

  /// Menambah XP dan mengembalikan info apakah terjadi Level Up
  bool addXp(int amount) {
    final oldLevel = currentLevel;
    xp += amount;
    return currentLevel > oldLevel;
  }

  /// Evaluasi badge otomatis
  List<BadgeItem> checkBadges({
    required int completedCount,
    required bool completedHighPriority,
    required int scheduleCount,
  }) {
    final newlyUnlocked = <BadgeItem>[];

    for (final b in badges) {
      if (b.isUnlocked) continue;

      bool unlock = false;
      if (b.id == 'first_task' && completedCount >= 1) unlock = true;
      if (b.id == 'high_priority' && completedHighPriority) unlock = true;
      if (b.id == 'anti_deadline' && completedCount >= 2) unlock = true;
      if (b.id == 'scheduler' && scheduleCount >= 2) unlock = true;
      if (b.id == 'five_tasks' && completedCount >= 5) unlock = true;

      if (unlock) {
        b.isUnlocked = true;
        xp += b.xpReward;
        newlyUnlocked.add(b);
      }
    }

    return newlyUnlocked;
  }
}
