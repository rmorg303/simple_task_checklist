import 'dart:async';
import '../models/task.dart';
import '../models/day_of_week.dart';
import '../util/task_db.dart';

class TaskBloc {
  // task db
  late final TaskDb db;

  // map to hold tasks
  late Map<DayOfWeek, List<Task>> taskMap;

  // stream controllers
  // allows multiple listeners
  final _taskStreamController =
    StreamController<Map<DayOfWeek, List<Task>>>.broadcast();

  // single subscription
  final _taskInsertController = StreamController<Task>();
  final _taskUpdateController = StreamController<Task>();
  final _taskDeleteController = StreamController<Task>();

  Stream<Map<DayOfWeek, List<Task>>> get tasks => _taskStreamController.stream;
  StreamSink<Map<DayOfWeek, List<Task>>> get taskSink => _taskStreamController.sink;
  StreamSink<Task> get taskInsertSink => _taskInsertController.sink;
  StreamSink<Task> get taskUpdateSink => _taskUpdateController.sink;
  StreamSink<Task> get taskDeleteSink => _taskDeleteController.sink;

  // close the streams after use
  void dispose() {
    _taskStreamController.close();
    _taskInsertController.close();
    _taskUpdateController.close();
    _taskDeleteController.close();
  }

  TaskBloc() {
    // singleton
    db = TaskDb();
    getTasks();
    _taskStreamController.stream.listen(returnTasks);
    _taskInsertController.stream.listen(_addTask);
    _taskUpdateController.stream.listen(_updateTask);
    _taskDeleteController.stream.listen(_deleteTask);
  }

  Future<void> getTasks() async {
    final Map<DayOfWeek, List<Task>> tasks = await db.getTaskMap();
    taskMap = tasks;
    taskSink.add(tasks);
  }

  Map<DayOfWeek,List<Task>> returnTasks(Map<DayOfWeek, List<Task>> tasks) {
    return tasks;
  }

  void _addTask(Task task) {
    db.insertTask(task).then((result) {
      getTasks();
    });
  }

  void _updateTask(Task task) {
    db.updateTask(task).then((result) {
      getTasks();
    });
  }
  void _deleteTask(Task task) {
    db.deleteTask(task).then((result) {
      getTasks();
    });
  }
}