import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management/screens/task_map_screen.dart';
import 'package:task_management/widgets/common/dropdown.dart';
import 'package:task_management/widgets/common/text_field.dart';
import 'add_or_edit_task_screen.dart';
import 'task_details_screen.dart';
import '../provider/task_provider.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final TextEditingController searchQuery = TextEditingController();
  String? selectedStatus;
  String? selectedPriority;
  bool showFilters = false;

  @override
  Widget build(BuildContext context) {
    final taskList = ref.watch(taskProvider);
    final filteredTasks = taskList.where((task) {
      final matchesSearch = searchQuery.text.isEmpty ||
          task.title.toLowerCase().contains(searchQuery.text.toLowerCase());
      final matchesStatus =
          selectedStatus == null || task.status == selectedStatus;
      final matchesPriority =
          selectedPriority == null || task.priority == selectedPriority;
      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Task List',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF01442C),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          if (showFilters) _buildFilterOptions(),
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(child: Text("No tasks found!"))
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return _buildTaskCard(context, task);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0xFF01442C),
            child: const Icon(Icons.map, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskMapScreen(tasks: taskList),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: const Color(0xFF01442C),
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskFormScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: searchQuery,
              hint: "Search tasks...",
              onChanged: (value) {
                setState(() {});
              },
              label: 'Search',
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.filter_list,
                color: showFilters ? Colors.green : Colors.grey),
            onPressed: () {
              setState(() {
                showFilters = !showFilters;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CustomDropdown(
            label: "Status",
            items: ["Completed", "InProgress", "Pending"],
            value: selectedStatus,
            onChanged: (value) {
              setState(() {
                selectedStatus = value;
              });
            },
          ),
          const SizedBox(height: 10),
          CustomDropdown(
            label: "Priority",
            items: ["High", "Medium", "Low"],
            value: selectedPriority,
            onChanged: (value) {
              setState(() {
                selectedPriority = value;
              });
            },
          ),
          if (selectedStatus != null || selectedPriority != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedStatus = null;
                    selectedPriority = null;
                  });
                },
                child: const Text("Clear Filters"),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _buildTaskCard(BuildContext context, dynamic task) {
  String formattedDate = task.dueDate != null
      ? DateFormat.yMMMd().format(DateTime.parse(task.dueDate))
      : 'No Due Date';

  return Card(
    elevation: 4,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      title: Text(
        task.title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          _buildStatusChip(task.status),
          const SizedBox(height: 5),
          Row(
            children: [
              _buildPriorityIcon(task.priority),
              const SizedBox(width: 10),
              Text(
                "Due: $formattedDate",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TaskDetailsScreen(task: task)),
      ),
    ),
  );
}

Widget _buildPriorityIcon(String priority) {
  IconData iconData;
  Color iconColor;

  switch (priority) {
    case 'High':
      iconData = Icons.keyboard_double_arrow_up;
      iconColor = Colors.red;
      break;
    case 'Medium':
      iconData = Icons.keyboard_arrow_up;
      iconColor = Colors.orange;
      break;
    case 'Low':
      iconData = Icons.keyboard_arrow_down;
      iconColor = Colors.green;
      break;
    default:
      iconData = Icons.remove;
      iconColor = Colors.grey;
  }

  return Row(
    children: [
      Icon(iconData, color: iconColor, size: 22),
      const SizedBox(width: 4),
      Text(priority,
          style: TextStyle(color: iconColor, fontWeight: FontWeight.bold)),
    ],
  );
}

Widget _buildStatusChip(String status) {
  Color chipColor;
  Color textColor = Colors.black;

  switch (status) {
    case 'Completed':
      chipColor = Colors.green.shade200;
      break;
    case 'InProgress':
      chipColor = Colors.amber.shade200;
      break;
    case 'Pending':
      chipColor = Colors.grey.shade300;
      break;
    default:
      chipColor = Colors.grey;
  }

  return Container(
    decoration: BoxDecoration(
      color: chipColor,
      borderRadius: BorderRadius.circular(20),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Text(
      status,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
