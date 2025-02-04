class Task {
  final int? id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final String? imagePath;
  final double? latitude;
  final double? longitude;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.imagePath,
    this.latitude,
    this.longitude,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'imagePath': imagePath,
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
      imagePath: map['imagePath'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
