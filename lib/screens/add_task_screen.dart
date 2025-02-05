import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/task_model.dart';
import '../provider/task_provider.dart';
import '../core/gps_service.dart';
import '../widgets/common/text_field.dart';
import '../widgets/common/dropdown.dart';
import '../widgets/common/button.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;
  String _priority = "Medium";
  List<File> _selectedImages = [];
  Position? _taskLocation;
  bool _isLocationLoading = false;
  late GoogleMapController _mapController;

  Future<void> pickedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
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
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _selectedDate?.toString() ?? DateTime.now().toString(),
        priority: _priority,
        imagePaths: _selectedImages.map((file) => file.path).toList(),
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
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Add Task',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10),
              CustomTextField(
                controller: _titleController,
                label: 'Task Title',
                hint: 'Enter task title',
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter task description',
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Date',
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  prefixIcon:
                      Icon(Icons.calendar_today, color: Color(0xFF0066FF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF0066FF), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                controller: _dateController,
                readOnly: true,
                onTap: () async {
                  await pickedDate(context);
                },
              ),
              const SizedBox(height: 10),
              CustomDropdown(
                value: _priority,
                items: ["Low", "Medium", "High"],
                onChanged: (value) {
                  setState(() => _priority = value!);
                },
                label: 'Priority',
              ),
              const SizedBox(height: 10),
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
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () => _removeImage(image),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : const Text('No images selected'),
              CommonButton(
                label: 'Pick Images',
                isLoading: false,
                onPressed: _pickImages,
                buttonType: ButtonType.primary,
              ),
              const SizedBox(height: 10),
              _isLocationLoading
                  ? Center(child: CircularProgressIndicator())
                  : _taskLocation != null
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
                                },
                              ),
                            ),
                          ],
                        )
                      : const Text('No location captured'),
              CommonButton(
                label: 'Capture Location',
                isLoading: _isLocationLoading,
                onPressed: _getLocation,
                buttonType: ButtonType.primary,
              ),
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
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CommonButton(
                  label: 'Cancel',
                  buttonType: ButtonType.secondary,
                  isLoading: false,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Expanded(
              child: CommonButton(
                label: 'Save Task',
                buttonType: ButtonType.primary,
                isLoading: false,
                onPressed: _saveTask,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
