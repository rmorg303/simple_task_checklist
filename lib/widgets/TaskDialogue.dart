import 'package:flutter/material.dart';
import '../models/Task.dart';
import '../util/DbHelper.dart';

class TaskDialogue {
  final _txtName = TextEditingController();
  final _txtDesc = TextEditingController();
  late TimeOfDay _timeOfDay;
  late final bool _isNew;
  late final Task task;

  TaskDialogue(this.task, this._isNew);

  Widget buildDialog(BuildContext context) {
    DbHelper helper = DbHelper();

    _txtName.text = task.name;
    _txtDesc.text = task.desc;


    String title = _isNew ? "New Task" : task.name;

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _txtName,
              decoration: const InputDecoration(
                hintText: "Name"
              ),
            ),
            TextField(
              controller: _txtDesc,
              decoration: const InputDecoration(
                hintText: "Description"
              )
            ),
            ElevatedButton(
              onPressed: () {
                _selectTimeOfDay(context);
              },
              child: const Text("Select Time")
            ),
            ElevatedButton(
              onPressed: () {
                  task.name = _txtName.text;
                  task.desc = _txtDesc.text;
                  task.time = _timeOfDay;
                  helper.insertTask(task);
                  Navigator.pop(context);
              },
              child: Text(_isNew ? "Save Task" : "Update Task")
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectTimeOfDay(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      _timeOfDay = pickedTime;
    }
  }
}