import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../core/database.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    loadTasks();
  }

  final DatabaseHelper dbHelper = DatabaseHelper();

  void loadTasks() async {
    state = await dbHelper.getTasks();
  }

  void addTask(Task task) async {
    await dbHelper.insertTask(task);
    loadTasks();
  }

  void deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    loadTasks();
  }

  void updateTask(Task updatedTask) {
    state = state
        .map((task) => task.id == updatedTask.id ? updatedTask : task)
        .toList();
  }
}

final statusProvider = StateNotifierProvider<StatusNotifier, String>((ref) {
  return StatusNotifier();
});

class StatusNotifier extends StateNotifier<String> {
  StatusNotifier() : super("All");

  void setStatus(String status) {
    state = status;
  }
}
