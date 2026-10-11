import 'package:flutter/material.dart';
import '/widgets/TaskDialogue.dart';
import 'models/Task.dart';

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
              Task(0, "", "", TimeOfDay(hour: 12, minute: 0),
                  List.empty(growable: true)),
              true);
          showDialog(
            context: context,
            builder: (context) => dialogue.buildDialog(context)
          );
        },
      ),
      body: Column(
        children:[
          const Text("Monday"),
          ListView(
            children: [
            ]
          ),
          const Text("Tuesday"),
          ListView(
              children: [
              ]
          ),
          const Text("Wednesday"),
          ListView(
              children: [
              ]
          ),
          const Text("Thursday"),
          ListView(
              children: [
              ]
          ),
          const Text("Friday"),
          ListView(
              children: [
              ]
          ),
          const Text("Saturday"),
          ListView(
              children: [
              ]
          ),
          const Text("Sunday"),
          ListView(
              children: [
              ]
          ),
        ],
      ),
    );
  }
}