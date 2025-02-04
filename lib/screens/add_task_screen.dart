import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../provider/task_provider.dart';
import '../core/gps_service.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _priority = "Medium";
  File? _selectedImage;
  Position? _taskLocation;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _getLocation() async {
    final location = await LocationService.getCurrentLocation();
    if (location != null) {
      setState(() => _taskLocation = location);
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: DateTime.now().toString(),
        priority: _priority,
        imagePath: _selectedImage?.path,
        latitude: _taskLocation?.latitude,
        longitude: _taskLocation?.longitude,
      );

      ref.read(taskProvider.notifier).addTask(newTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              DropdownButtonFormField(
                value: _priority,
                items: ["Low", "Medium", "High"]
                    .map((priority) => DropdownMenuItem(
                        value: priority, child: Text(priority)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _priority = value as String),
                decoration: InputDecoration(labelText: 'Priority'),
              ),
              SizedBox(height: 10),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 100)
                  : Text('No image selected'),
              ElevatedButton.icon(
                icon: Icon(Icons.image),
                label: Text('Pick Image'),
                onPressed: _pickImage,
              ),
              SizedBox(height: 10),
              _taskLocation != null
                  ? Text(
                      'Location: ${_taskLocation!.latitude}, ${_taskLocation!.longitude}')
                  : Text('No location captured'),
              ElevatedButton.icon(
                icon: Icon(Icons.location_on),
                label: Text('Capture Location'),
                onPressed: _getLocation,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save Task'),
                onPressed: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
