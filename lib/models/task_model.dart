import 'dart:convert';

class Task {
  final int? id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final List<String>? imagePaths;
  final double? latitude;
  final double? longitude;
  final bool isCompleted;
  final String status;

  Task(
      {this.id,
      required this.title,
      required this.description,
      required this.dueDate,
      required this.priority,
      required this.status,
      this.imagePaths,
      this.latitude,
      this.longitude,
      this.isCompleted = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'imagePaths': json.encode(imagePaths),
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      priority: map['priority'],
      imagePaths: map['imagePaths'] != null
          ? List<String>.from(json.decode(map['imagePaths']))
          : [],
      latitude: map['latitude'],
      longitude: map['longitude'],
      status: map['status'],
    );
  }
}
