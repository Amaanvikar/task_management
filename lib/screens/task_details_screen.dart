import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task_management/screens/edit_task_screen.dart';
import '../models/task_model.dart';
import '../provider/task_provider.dart';
import '../widgets/common/button.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final Task task;

  TaskDetailsScreen({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LatLng? taskLocation = (task.latitude != null && task.longitude != null)
        ? LatLng(task.latitude!, task.longitude!)
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          task.title,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskScreen(task: task),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Delete Task', style: GoogleFonts.poppins()),
                  content: Text(
                    'Are you sure you want to delete this task?',
                    style: GoogleFonts.poppins(),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(color: Colors.blue),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(taskProvider.notifier).deleteTask(task.id!);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Delete',
                        style: GoogleFonts.poppins(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.description,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Due Date: ${task.dueDate}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Priority: ${task.priority}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: task.priority == 'High'
                      ? Colors.red
                      : task.priority == 'Medium'
                          ? Colors.orange
                          : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              if (task.imagePaths != null && task.imagePaths!.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: task.imagePaths!
                        .map(
                          (imagePath) => Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.file(
                                File(imagePath),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    'No images available',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ),
              const SizedBox(height: 25),
              if (taskLocation != null)
                SizedBox(
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
              const SizedBox(height: 25),
              CommonButton(
                label: 'Delete Task',
                buttonType: ButtonType.secondary,
                isLoading: false,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Delete Task', style: GoogleFonts.poppins()),
                      content: Text(
                        'Are you sure you want to delete this task?',
                        style: GoogleFonts.poppins(),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(color: Colors.blue),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(taskProvider.notifier)
                                .deleteTask(task.id!);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Delete',
                            style: GoogleFonts.poppins(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
