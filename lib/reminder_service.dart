import 'models/task_model.dart';

/// Jendela waktu "akan datang" — tugas dianggap butuh pengingat
/// kalau deadline-nya kurang dari durasi ini lagi.
const Duration kReminderWindow = Duration(hours: 1);

class ReminderInfo {
  final Task task;
  final bool overdue;
  ReminderInfo(this.task, this.overdue);
}

/// Ambil semua tugas yang butuh pengingat (mendekati deadline atau sudah lewat).
List<ReminderInfo> collectReminders(List<Task> tasks) {
  final result = <ReminderInfo>[];
  for (final t in tasks) {
    if (t.done || t.deadline == null) continue;
    if (t.isOverdue) {
      result.add(ReminderInfo(t, true));
    } else if (t.isDueSoon(kReminderWindow)) {
      result.add(ReminderInfo(t, false));
    }
  }
  // urutkan: yang paling mendesak (deadline terdekat) di atas
  result.sort((a, b) => a.task.deadline!.compareTo(b.task.deadline!));
  return result;
}

String formatDeadline(DateTime dt) {
  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final h = dt.hour.toString().padLeft(2, '0');
  final min = dt.minute.toString().padLeft(2, '0');
  return "$d/$m/${dt.year} $h:$min";
}

String timeUntil(DateTime dt) {
  final diff = dt.difference(DateTime.now());
  if (diff.isNegative) {
    final over = diff.abs();
    if (over.inDays > 0) return "Terlambat ${over.inDays} hari";
    if (over.inHours > 0) return "Terlambat ${over.inHours} jam";
    return "Terlambat ${over.inMinutes} menit";
  }
  if (diff.inHours > 0) return "${diff.inHours} jam lagi";
  return "${diff.inMinutes} menit lagi";
}
