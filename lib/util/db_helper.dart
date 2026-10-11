import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DbHelper {
  final int version = 1;

  // nullable database
  Database? db;

  //singleton pattern
  static final DbHelper _dbHelper = DbHelper._internal();

  // internal constructor
  DbHelper._internal();

  // factory method to return the single instance of the database helper
  factory DbHelper() {
    return _dbHelper;
  }

  // openDb
  Future<Database?> openDb() async {
    // if the database is null (??=) the create it. If not, return the database.
    db ??= await openDatabase(join(await getDatabasesPath(), 'tasklist.db'),
        onCreate: (database, version) {
          database.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, "
              "title TEXT, desc TEXT, time TIME, days TEXT)");
        },
        version: version);
    return db;
  }

  Future<int?> insertTask(Task task) async {
    // insert the task as a map into the database.
    int? id = await db?.insert('tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    return id;
  }

  Future<List<Task>> fetchTasksFromDay(String dayOfWeek) async {
    final List<Map<String, dynamic>>? maps =
      await db?.query('tasks',
      where: 'days LIKE ?',
      whereArgs: ['%$dayOfWeek%']);

    if (maps == null || maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }
}