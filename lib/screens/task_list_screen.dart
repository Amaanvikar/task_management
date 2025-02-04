import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_task_screen.dart';
import 'task_details_screen.dart';
import '../provider/task_provider.dart';
import '../models/task_model.dart';
import 'dart:io';

class TaskListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskList = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: taskList.isEmpty
          ? Center(child: Text("No tasks added yet!"))
          : ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final task = taskList[index];

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: task.imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(task.imagePath!),
                                width: 50, height: 50, fit: BoxFit.cover),
                          )
                        : Icon(Icons.task, size: 40, color: Colors.blue),
                    title: Text(task.title,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Priority: ${task.priority}"),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskDetailsScreen(task: task)),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskFormScreen()),
        ),
      ),
    );
  }
}
