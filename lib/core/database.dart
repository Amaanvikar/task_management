import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = "tasks";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return openDatabase(path, version: 3, onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY, "
        "title TEXT, "
        "description TEXT, "
        "dueDate TEXT, "
        "priority TEXT, "
        "imagePaths TEXT, "
        "latitude REAL, "
        "longitude REAL, "
        "status TEXT "
        ")",
      );
    });
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(tableName, task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTaskStatus(int id, String status) async {
    final db = await database;
    await db.update(
      tableName,
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
