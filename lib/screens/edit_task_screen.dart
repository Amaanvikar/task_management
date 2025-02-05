import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../provider/task_provider.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late String selectedPriority;
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    selectedPriority = widget.task.priority;
    isCompleted = widget.task.isCompleted;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedTask = widget.task.copyWith(
      title: titleController.text,
      description: descriptionController.text,
      priority: selectedPriority,
      isCompleted: isCompleted,
    );

    ref.read(taskProvider.notifier).updateTask(updatedTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Edit Task",
          style: GoogleFonts.poppins(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputCard(
              title: "Task Title",
              child: TextField(
                controller: titleController,
                decoration: _inputDecoration("Enter task title"),
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            _buildInputCard(
              title: "Task Description",
              child: TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: _inputDecoration("Enter task description"),
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            _buildInputCard(
              title: "Priority",
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedPriority,
                  isExpanded: true,
                  items: ["High", "Medium", "Low"]
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(
                              priority,
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildInputCard(
              title: "Completion Status",
              child: SwitchListTile(
                activeColor: Colors.blueAccent,
                value: isCompleted,
                title: Text("Mark as Completed",
                    style: GoogleFonts.poppins(fontSize: 16)),
                onChanged: (value) {
                  setState(() {
                    isCompleted = value;
                  });
                },
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _saveChanges,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.indigoAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Save Changes",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
      border: InputBorder.none,
    );
  }
}
