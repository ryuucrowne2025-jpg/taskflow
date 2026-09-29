import 'package:flutter/material.dart';

const List<String> kHariList = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

class ScheduleItem {
  String id;
  String matkul;
  String hari; // salah satu dari kHariList
  TimeOfDay jamMulai;
  TimeOfDay jamSelesai;

  ScheduleItem({
    required this.id,
    required this.matkul,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
  });

  String formatJam(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  String get jamRange => "${formatJam(jamMulai)} - ${formatJam(jamSelesai)}";
}
