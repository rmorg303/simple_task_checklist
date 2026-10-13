import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_form.dart';

class TaskDialog {
  // these will be passed into the form
  late final bool _isNew;
  late final Task _task;

  TaskDialog(this._task, this._isNew);

  Widget buildDialog(BuildContext context) {

    String title = _isNew ? "New Task" : _task.name;

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        // separated the form from the dialog box for easier readability
        child: TaskForm(task: _task, isNew: _isNew))
      );
  }
}