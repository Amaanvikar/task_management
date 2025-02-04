import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/task_model.dart';
import '../provider/task_provider.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final Task task;

  TaskDetailsScreen({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LatLng? taskLocation = (task.latitude != null && task.longitude != null)
        ? LatLng(task.latitude!, task.longitude!)
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Due Date: ${task.dueDate}",
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Text("Priority: ${task.priority}",
                style: TextStyle(color: Colors.blue)),
            if (task.imagePath != null)
              Image.file(File(task.imagePath!), height: 150),
            if (taskLocation != null)
              Container(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: taskLocation,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('taskLocation'),
                      position: taskLocation,
                      infoWindow: InfoWindow(title: 'Task Location'),
                    ),
                  },
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.delete),
              label: Text('Delete Task'),
              onPressed: () {
                ref.read(taskProvider.notifier).deleteTask(task.id!);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
