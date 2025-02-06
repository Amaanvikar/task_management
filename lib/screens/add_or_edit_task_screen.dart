import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task_management/screens/map_screen.dart';
import '../models/task_model.dart';
import '../provider/task_provider.dart';
import '../core/gps_service.dart';
import '../widgets/common/text_field.dart';
import '../widgets/common/dropdown.dart';
import '../widgets/common/button.dart';
import 'package:intl/intl.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final TextEditingController _dueDateController = new TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  late String _priority;
  late String _status;
  List<File> _selectedImages = [];
  Position? _taskLocation;
  bool _isLocationLoading = false;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority ?? "Low";
    _status = widget.task?.status ?? "Todo";
    _selectedImages =
        widget.task?.imagePaths?.map((path) => File(path)).toList() ?? [];
    if (widget.task != null &&
        widget.task!.latitude != null &&
        widget.task!.longitude != null) {
      _taskLocation = Position(
        latitude: widget.task!.latitude!,
        longitude: widget.task!.longitude!,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    } else {
      _getLocation();
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null &&
        _selectedImages.length + pickedFiles.length <= 5) {
      setState(() {
        _selectedImages
            .addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can select only 5 images.')),
      );
    }
  }

  Future<void> _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _removeImage(File image) {
    setState(() {
      _selectedImages.remove(image);
    });
  }

  Future<void> _getLocation() async {
    setState(() {
      _isLocationLoading = true;
    });
    final location = await LocationService.getCurrentLocation();
    setState(() {
      _taskLocation = location;
      _isLocationLoading = false;
    });
    if (_mapController != null && _taskLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(
            LatLng(_taskLocation!.latitude, _taskLocation!.longitude)),
      );
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: widget.task?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: DateTime.now().toString(),
        priority: _priority,
        status: _status,
        imagePaths: _selectedImages.map((file) => file.path).toList(),
        latitude: _taskLocation?.latitude,
        longitude: _taskLocation?.longitude,
      );

      if (widget.task == null) {
        ref.read(taskProvider.notifier).addTask(newTask);
        Navigator.pop(context);
      } else {
        ref.read(taskProvider.notifier).updateTask(newTask);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  Future<void> _openMapScreen() async {
    final LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          initialLocation: _taskLocation != null
              ? LatLng(_taskLocation!.latitude, _taskLocation!.longitude)
              : null,
        ),
      ),
    );

    if (pickedLocation != null) {
      setState(() {
        _taskLocation = Position(
          latitude: pickedLocation.latitude,
          longitude: pickedLocation.longitude,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.task != null) ? 'Edit Task' : 'Add Task',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF01442C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(
                  controller: _titleController,
                  label: 'Task Title',
                  hint: 'Enter task title',
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a title' : null),
              SizedBox(height: 10),
              CustomTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  hint: 'Enter task description',
                  maxLines: 3),
              SizedBox(height: 10),
              CustomTextField(
                controller: _dueDateController,
                label: 'Due Date',
                hint: 'Select due date',
                onTap: _pickDueDate,
              ),
              SizedBox(height: 10),
              CustomDropdown(
                  value: _priority,
                  items: ["Low", "Medium", "High"],
                  onChanged: (value) => setState(() => _priority = value!),
                  label: 'Priority'),
              SizedBox(height: 10),
              CustomDropdown(
                  value: _status,
                  items: ["Todo", "InProgress", "Completed"],
                  onChanged: (value) => setState(() => _status = value!),
                  label: 'Status'),
              SizedBox(height: 10),
              _selectedImages.isNotEmpty
                  ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          final image = _selectedImages[index];
                          return Stack(
                            children: [
                              Image.file(image,
                                  height: 80, width: 80, fit: BoxFit.cover),
                              Positioned(
                                  right: 0,
                                  child: IconButton(
                                      icon:
                                          Icon(Icons.close, color: Colors.red),
                                      onPressed: () => _removeImage(image))),
                            ],
                          );
                        },
                      ),
                    )
                  : Text('No images selected'),
              CommonButton(
                  label: 'Pick Images',
                  isLoading: false,
                  onPressed: _pickImages),
              SizedBox(height: 10),
              _taskLocation != null
                  ? Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: GoogleMap(
                              onMapCreated: (controller) {
                                _mapController = controller;
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(_taskLocation!.latitude,
                                    _taskLocation!.longitude),
                                zoom: 14.0,
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId('task_location'),
                                  position: LatLng(_taskLocation!.latitude,
                                      _taskLocation!.longitude),
                                ),
                              }),
                        ),
                      ],
                    )
                  : const Text('No location captured'),
              CommonButton(
                  label: 'Tap to open map',
                  isLoading: _isLocationLoading,
                  onPressed: _openMapScreen),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: CommonButton(
                    label: 'Cancel',
                    buttonType: ButtonType.secondary,
                    isLoading: false,
                    onPressed: () => Navigator.pop(context))),
            const SizedBox(width: 10),
            Expanded(
                child: CommonButton(
                    label: widget.task != null ? 'Edit Task' : 'Save Task',
                    buttonType: ButtonType.primary,
                    isLoading: false,
                    onPressed: _saveTask)),
          ],
        ),
      ),
    );
  }
}
