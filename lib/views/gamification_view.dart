import 'package:flutter/material.dart';
import '../models/gamification_model.dart';

class GamificationView extends StatelessWidget {
  final GamificationManager gamification;
  final int completedTasksCount;
  final int totalTasksCount;

  const GamificationView({
    super.key,
    required this.gamification,
    required this.completedTasksCount,
    required this.totalTasksCount,
  });

  @override
  Widget build(BuildContext context) {
    final level = gamification.currentLevelInfo;
    final progress = gamification.levelProgress;
    final unlockedCount = gamification.badges.where((b) => b.isUnlocked).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 HERO LEVEL & XP CARD (Glassmorphism & Gradient)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E1B4B),
                  const Color(0xFF312E81),
                  level.color.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: level.color.withOpacity(0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: level.color.withOpacity(0.2),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Level Avatar Badge
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [level.color, const Color(0xFF6366F1)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: level.color.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Lv.${level.level}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                level.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.orangeAccent.withOpacity(0.5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department_rounded,
                                      color: Colors.orangeAccent,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${gamification.streak} Hari",
                                      style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Total ${gamification.xp} XP akumulasi",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // XP Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                level.color,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${(progress * 100).toInt()}% menuju Level ${level.level + 1}",
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11.5,
                                ),
                              ),
                              Text(
                                "${gamification.xpToNextLevel} XP lagi",
                                style: TextStyle(
                                  color: level.color,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 📊 STATS SUMMARY ROW
          Row(
            children: [
              _buildMiniStat(
                label: 'Tugas Selesai',
                value: '$completedTasksCount',
                icon: Icons.check_circle_outline_rounded,
                color: const Color(0xFF10B981),
              ),
              const SizedBox(width: 12),
              _buildMiniStat(
                label: 'Total XP',
                value: '${gamification.xp}',
                icon: Icons.bolt_rounded,
                color: const Color(0xFFFBBF24),
              ),
              const SizedBox(width: 12),
              _buildMiniStat(
                label: 'Medali Dibuka',
                value: '$unlockedCount / ${gamification.badges.length}',
                icon: Icons.military_tech_rounded,
                color: const Color(0xFFA855F7),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // 🎯 MISI HARIAN (DAILY QUESTS)
          Row(
            children: const [
              Icon(Icons.track_changes_rounded, color: Color(0xFF60A5FA), size: 20),
              SizedBox(width: 8),
              Text(
                "Misi Harian (Daily Quests)",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildQuestItem(
            title: "Selesaikan 1 Tugas Hari Ini",
            rewardXp: "+50 XP",
            isDone: completedTasksCount >= 1,
            progressText: completedTasksCount >= 1 ? "1/1 Selesai" : "0/1",
          ),
          _buildQuestItem(
            title: "Selesaikan Tugas Prioritas Tinggi",
            rewardXp: "+100 XP",
            isDone: completedTasksCount >= 2,
            progressText: completedTasksCount >= 2 ? "Selesai" : "Belum",
          ),
          _buildQuestItem(
            title: "Cek & Perbarui Jadwal Kuliah",
            rewardXp: "+40 XP",
            isDone: true,
            progressText: "Aktif",
          ),

          const SizedBox(height: 28),

          // 🎖️ PENCAPAIAN & MEDALI (ACHIEVEMENTS)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFFFBBF24),
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Pencapaian & Medali",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                "$unlockedCount/${gamification.badges.length} Terbuka",
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // BADGES LIST
          Column(
            children: gamification.badges.map((b) => _buildBadgeCard(b)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF141A2A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestItem({
    required String title,
    required String rewardXp,
    required bool isDone,
    required String progressText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF141A2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone
              ? const Color(0xFF10B981).withOpacity(0.3)
              : Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isDone
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: isDone ? const Color(0xFF10B981) : Colors.white38,
            size: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: isDone ? FontWeight.normal : FontWeight.w600,
                    decoration:
                        isDone ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  progressText,
                  style: TextStyle(
                    color: isDone ? const Color(0xFF10B981) : Colors.white54,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFBBF24).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              rewardXp,
              style: const TextStyle(
                color: Color(0xFFFBBF24),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(BadgeItem badge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: badge.isUnlocked
            ? const Color(0xFF181F38)
            : const Color(0xFF121727).withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badge.isUnlocked
              ? badge.color.withOpacity(0.4)
              : Colors.white.withOpacity(0.05),
          width: badge.isUnlocked ? 1.5 : 1,
        ),
        boxShadow: badge.isUnlocked
            ? [
                BoxShadow(
                  color: badge.color.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: badge.isUnlocked
                  ? badge.color.withOpacity(0.2)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: badge.isUnlocked ? badge.color : Colors.white12,
              ),
            ),
            child: Icon(
              badge.isUnlocked ? badge.icon : Icons.lock_outline_rounded,
              color: badge.isUnlocked ? badge.color : Colors.white24,
              size: 24,
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
                      badge.title,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: badge.isUnlocked ? Colors.white : Colors.white38,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (badge.isUnlocked)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF10B981),
                        size: 15,
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  badge.description,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        badge.isUnlocked ? Colors.white60 : Colors.white24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badge.isUnlocked
                  ? const Color(0xFFFBBF24).withOpacity(0.15)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "+${badge.xpReward} XP",
              style: TextStyle(
                color: badge.isUnlocked
                    ? const Color(0xFFFBBF24)
                    : Colors.white24,
                fontWeight: FontWeight.bold,
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
