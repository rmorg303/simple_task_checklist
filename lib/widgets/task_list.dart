import 'package:flutter/material.dart';
import 'task_dialog.dart';
import '../models/task.dart';
import '../models/day_of_week.dart';
import '../util/task_db.dart';
import '../bloc/task_bloc.dart';
import 'task_tile.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late final TaskDb db;
  late TaskBloc taskBloc;

  @override
  initState() {
      super.initState();
      taskBloc = TaskBloc();
      db = TaskDb();
  }

  @override
  void dispose() {
    taskBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get the taskMap from the BLoC
    Map<DayOfWeek, List<Task>> taskMap = taskBloc.taskMap;


    final TextStyle txtStyle = TextStyle (
      fontSize: 24
    );

    return MaterialApp(
        title: "Simple Tasklist",

        home: Scaffold(
          appBar: AppBar(
              title: const Text("Simple Tasklist")
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add_task),
            onPressed: () {
              TaskDialog dialog = TaskDialog(
                  Task(id: 0, name: "", desc: "",
                      time: TimeOfDay(hour: 12, minute: 0),
                      days: List.empty(growable: true)),
                  true);
              showDialog(
                  context: context,
                  builder: (context) => dialog.buildDialog(context)
              );
            },
          ),
          body: Center(
              child: Column(
                children:[
                  ListView.builder(
                    itemCount: DayOfWeek.values.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DayOfWeek day = DayOfWeek.values[index];
                      return Column(
                        children: [
                          Text(day.name[0].toUpperCase() +
                          day.name.substring(1, day.name.length)),
                          for (var task in  taskMap[day]!)
                            TaskTile(
                              task: task,
                            )
                        ]
                      );
                    },
                  )
                ],
              )
          )
        )
    );
  }
}