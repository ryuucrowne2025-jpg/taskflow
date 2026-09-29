import 'package:get/get.dart';
import '../models/task_model.dart';

class HomeController extends GetxController {
  final RxList<TaskModel> tasks = <TaskModel>[
    TaskModel(id: '1', title: 'Design UI', done: true),
    TaskModel(id: '2', title: 'Build App', done: false),
  ].obs;

  final RxInt selectedIndex = 0.obs;

  int get totalCount => tasks.length;
  int get doneCount => tasks.where((t) => t.done).length;
  int get pendingCount => tasks.where((t) => !t.done).length;

  List<TaskModel> get completedTasks => tasks.where((t) => t.done).toList();

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void addTask(String title) {
    if (title.trim().isEmpty) return;
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    tasks.add(newTask);
  }

  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
  }

  void toggleTask(String id) {
    final task = tasks.firstWhereOrNull((t) => t.id == id);
    if (task != null) {
      task.done = !task.done;
      tasks.refresh();
    }
  }
}
