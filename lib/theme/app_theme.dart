class TaskModel {
  String id;
  String title;
  bool done;

  TaskModel({required this.id, required this.title, this.done = false});
}
