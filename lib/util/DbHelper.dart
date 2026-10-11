import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/Task.dart';

class DbHelper {
  final int version = 1;

  // nullable database
  Database? db;

  //singleton pattern
  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database?> openDb() async {
    // if the database is null (??=) the create it. If not, return the database.
    db ??= await openDatabase(join(await getDatabasesPath(), 'tasklist.db'),
        onCreate: (database, version) {
          database.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, desc TEXT, time TIME, days TEXT)");
        },
        version: version);
    return db;
  }

  Future<int?> insertTask(Task task) async {
    int? id = await db?.insert('tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    return id;
  }
}