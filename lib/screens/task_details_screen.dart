import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:task_management/screens/add_or_edit_task_screen.dart';
import '../models/task_model.dart';
import '../provider/task_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LatLng? taskLocation = (task.latitude != null && task.longitude != null)
        ? LatLng(task.latitude!, task.longitude!)
        : null;

    String formattedDate = task.dueDate != null
        ? DateFormat.yMMMMd().format(DateTime.parse(task.dueDate))
        : 'No due date';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF01442C),
        title: Text(
          'Task Details',
          style: GoogleFonts.inter(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskFormScreen(task: task),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              _showDeleteDialog(context, ref);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: GoogleFonts.inter(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.description, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(task.description,
                        style: GoogleFonts.inter(
                            fontSize: 16, color: Colors.black87)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 10),
                  Text(
                    "Due Date: $formattedDate",
                    style: GoogleFonts.inter(
                        fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(Icons.priority_high, color: Colors.grey),
                  const SizedBox(width: 10),
                  Text("Priority:",
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: task.priority == 'High'
                          ? const Color(0xFFFFCCCB) // Light Matte Red
                          : task.priority == 'Medium'
                              ? const Color(0xFFFFE0B2) // Light Matte Orange
                              : const Color(0xFFC8E6C9), // Light Matte Green
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      task.priority,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.grey),
                  const SizedBox(width: 10),
                  Text("Status:",
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: task.status == 'Completed'
                          ? const Color(0xFFB3E5FC) // Light Matte Blue
                          : task.status == 'InProgress'
                              ? const Color(0xFFFFE0B2) // Light Matte Orange
                              : const Color(0xFFE0E0E0), // Light Matte Grey
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      task.status,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (task.imagePaths != null && task.imagePaths!.isNotEmpty) ...[
                Text("Attachments",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: task.imagePaths!
                        .map((imagePath) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  File(imagePath),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ] else
                Row(
                  children: [
                    const Icon(Icons.image_not_supported, color: Colors.grey),
                    const SizedBox(width: 10),
                    Text('No images available', style: GoogleFonts.inter()),
                  ],
                ),
              const SizedBox(height: 20),
              if (taskLocation != null) ...[
                Text("Task Location",
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: taskLocation,
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('taskLocation'),
                          position: taskLocation,
                          infoWindow: const InfoWindow(title: 'Task Location'),
                        ),
                      },
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Delete Task', style: GoogleFonts.inter()),
        content: Text('Are you sure you want to delete this task?',
            style: GoogleFonts.inter()),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: GoogleFonts.inter()),
          ),
          TextButton(
              onPressed: () {
                ref.read(taskProvider.notifier).deleteTask(task.id!);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Delete', style: GoogleFonts.inter())),
        ],
      ),
    );
  }
}
