import 'package:flutter/material.dart';
import 'widgets/task_list.dart';

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
