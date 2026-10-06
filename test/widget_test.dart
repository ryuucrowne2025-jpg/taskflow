import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:task_app/views/login_view.dart';
import 'package:task_app/views/tasks_view.dart';
import 'package:task_app/models/task_model.dart';

void main() {
  testWidgets('NFR-001 - Password pada Login harus di-obscure', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));

    final passwordField = tester.widget<TextField>(
      find.byType(TextField).at(1),
    );

    expect(passwordField.obscureText, true);
  });

  testWidgets('NFR-002 - Login dengan input kosong harus ditolak', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginView()));

    await tester.tap(find.text('Login'));

    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Welcome Back 👋'), findsOneWidget);
  });

  testWidgets('NFR-003 - Toggle status tugas harus memanggil callback', (
    WidgetTester tester,
  ) async {
    bool toggleDipanggil = false;

    final task = Task(
      id: '1',
      title: 'Tugas Pemrograman',
      category: 'Kuliah',
      done: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TasksView(
            tasks: [task],
            onToggle: (Task task) {
              toggleDipanggil = true;
              task.done = !task.done;
            },
            onDelete: (_) {},
            onEdit: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Tugas Pemrograman'), findsOneWidget);

    final toggle = find.byType(AnimatedContainer);

    expect(toggle, findsOneWidget);

    await tester.tap(toggle);
    await tester.pump();

    expect(toggleDipanggil, true);
    expect(task.done, true);
  });

  test('NFR-004 - Perubahan status tugas tetap konsisten dengan statistik', () {
    final tasks = [
      Task(id: '1', title: 'Tugas 1', done: false),
      Task(id: '2', title: 'Tugas 2', done: true),
      Task(id: '3', title: 'Tugas 3', done: false),
    ];

    int total = tasks.length;
    int done = tasks.where((task) => task.done).length;
    int pending = tasks.where((task) => !task.done).length;

    // Kondisi awal
    expect(total, 3);
    expect(done, 1);
    expect(pending, 2);
    expect(total, done + pending);

    // Ubah satu tugas dari Pending menjadi Done
    tasks[0].done = true;

    total = tasks.length;
    done = tasks.where((task) => task.done).length;
    pending = tasks.where((task) => !task.done).length;

    // Kondisi setelah perubahan status
    expect(total, 3);
    expect(done, 2);
    expect(pending, 1);
    expect(total, done + pending);
  });
}
