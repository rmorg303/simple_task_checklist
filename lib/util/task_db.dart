import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import '../models/task.dart';
import '../models/day_of_week.dart';

class TaskDb {
  // singleton SEMBAST and private constructor
  static final TaskDb _singleton = TaskDb._internal();
  TaskDb._internal();

  // factory constructor to return the singleton instance
  factory TaskDb() {
    return _singleton;
  }

  DatabaseFactory dbFactory = databaseFactoryIo;

  // where the database is stored
  final store = intMapStoreFactory.store('tasks');

  // database itself
  Database? _database;

  Future<Database> get database async {
    // if the database is null, open the database
    _database ??= await _openDb().then((db) {
      _database = db;
    });
      return _database!;
  }

  // open the database
  Future<Database> _openDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, 'tasks.db');
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  // insert a task
  Future<void> insertTask(Task task) async {
    final db = await database;
    await store.add(db, task.toMap());
  }

  // update a task
  Future<void> updateTask(Task task) async {
    final db = await database;
    final finder = _getFinderById(task.id);
    await store.update(db, task.toMap(), finder: finder);
  }

  // delete a singular task
  Future<void> deleteTask(Task task) async {
    final db = await database;
    final finder = _getFinderById(task.id);
    await store.delete(db, finder: finder);
  }

  // delete the entire database.
  Future<void> deleteAll() async {
    final db = await database;
    await store.delete(db);
  }

  // get all tasks.
  Future<List<Task>> getTasks() async {
    final db = await database;
    final finder = _getTimeSortedFinder();

    return _mapSnapshot(await store.find(db, finder: finder));
  }

  Future<Map<DayOfWeek,List<Task>>> getTaskMap() async {
    final taskMap = <DayOfWeek, List<Task>>{};
    for (var day in DayOfWeek.values) {
      taskMap[day] = await getTasksByDay(day);
    }

    return taskMap;
  }

  // get tasks if they are to be done that day of the week.
  Future<List<Task>> getTasksByDay(DayOfWeek day) async {
    final db = await database;
    final finder = _getTimeSortedFinder();
    finder.filter = Filter.arrayContains('days', day);

    return  _mapSnapshot(await store.find(db, finder: finder));
  }

  // takes a snapshot and maps it to a list of task objects
  List<Task> _mapSnapshot(
      List<RecordSnapshot<int, Map<String, Object?>>> snapshot) {
    return snapshot.map((snapshot) {
      final task = Task.fromMap(snapshot.value);
      task.id = snapshot.key;
      return task;
    }).toList();
  }

  // find an object by its id.
  Finder _getFinderById(int? id) {
    return Finder(filter: Filter.byKey(id));
  }

  // sort objects by their time and id.
  Finder _getTimeSortedFinder() {
    return Finder(sortOrders: [
      SortOrder('time'),
      SortOrder('id')
    ]);
  }

}