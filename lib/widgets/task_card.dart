import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
        trailing: Icon(task.isCompleted ? Icons.check_circle : Icons.pending),
      ),
    );
  }
}
