import 'package:flutter/material.dart';
import 'widgets/task_dialog.dart';
import 'models/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Simple Tasklist",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TaskList()
    );
  }
}

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Tasklist")
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_task),
        onPressed: () {
          TaskDialogue dialogue = TaskDialogue(
              Task(id: 0, name: "", desc: "",
                  time: TimeOfDay(hour: 12, minute: 0),
                  days: List.empty(growable: true)),
              true);
          showDialog(
            context: context,
            builder: (context) => dialogue.buildDialog(context)
          );
        },
      ),
      body: Column(
      )
    );
  }
}