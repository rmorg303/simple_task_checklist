import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(task.name),
        child: ListTile(
          title: Text(task.name),
          tileColor: Colors.blueAccent,
        ),
    );
  }
}