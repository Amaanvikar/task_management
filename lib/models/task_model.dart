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

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.imagePaths,
    this.latitude,
    this.longitude,
    this.isCompleted = false,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? dueDate,
    String? priority,
    List<String>? imagePaths,
    double? latitude,
    double? longitude,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      imagePaths: imagePaths ?? this.imagePaths,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

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
      'isCompleted': isCompleted ? 1 : 0,
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
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
