import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/day_of_week.dart';
import '../util/task_db.dart';

class TaskForm extends StatefulWidget {
  final Task task;
  final bool isNew;

  const TaskForm({super.key, required this.task, required this.isNew});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  // form key for validation.
  late final _formKey = GlobalKey<FormState>();

  // database helper
  late final TaskDb db;

  // txt controllers for inputting values
  final _txtName = TextEditingController();
  final _txtDesc = TextEditingController();
  final _txtTime = TextEditingController();

  // the task. Will be instantiated in initState
  late Task _task;

  // The time the task should be accomplished. Will be instantiated later.
  late TimeOfDay _timeOfDay;

  final Map<DayOfWeek, bool> _selectedDays = {
    for (var day in DayOfWeek.values) day: false,
  };

  // get the task passed into the widget,
  @override
  void initState() {
    super.initState();
    _task = widget.task;
    db = TaskDb();
  }

  @override
  Widget build(BuildContext context) {
    // return a form
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          spacing: 8.0,
          children: [
            TextFormField(
              // validation. all tasks must have a name
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please give the task a name.";
                }
                return null;
              },
              controller: _txtName,
              decoration: const InputDecoration(
                  hintText: "Name"
              ),
            ),
            TextFormField(
                // validation. all tasks must have a description
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please give the task a description.";
                  }
                  return null;
                },
                controller: _txtDesc,
                decoration: const InputDecoration(
                    hintText: "Description"
                )
            ),
            TextFormField(
              // validation. all tasks must have a time of day.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please choose a time of day.";
                }
                return null;
              },
              controller: _txtTime,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: "Time"
              ),
              // wrap the method in a callback
              onTap: () => _selectTimeOfDay(context),
            ),
            FormField<Map<DayOfWeek, bool>> (
              initialValue: _selectedDays,
              // validation. At least one day should be selected.
              validator: (daysMap) {
                if (daysMap == null || !daysMap.values.contains(true)) {
                  return "Please select at least one day.";
                }
                return "";
              },
              builder: (FormFieldState<Map<DayOfWeek, bool>> state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    for (var day in DayOfWeek.values)
                      CheckboxListTile(
                          title: Text(day.name.toUpperCase()),
                          value: _selectedDays[day],
                          onChanged: (bool? newValue) {
                            setState(() {
                              _selectedDays[day] = newValue ?? false;
                            });
                          }
                      ),
                  ]
                );
            }
            ),
            ElevatedButton(
                onPressed: () {
                  /*
                    if the form is valid, update the task and send if off to
                    the database. Inform user via snackbar.
                  */
                  if (_formKey.currentState!.validate()) {
                    _task.name = _txtName.text;
                    _task.desc = _txtDesc.text;
                    _task.time = _timeOfDay;
                    _task.days = DayOfWeek.values
                        .where((day) => _selectedDays[day] == true).toList();
                    db.insertTask(_task);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Saving task ${_task.name}"),
                        )
                    );
                    Navigator.pop(context);
                  }
                  // do NOT pop the widget if it is not validated.
                },
                child: Text(widget.isNew ? "Save Task" : "Update Task")
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectTimeOfDay(BuildContext context) async {
    // waits for the showTimePicker to return
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    /*
      if its not null, assign the value to _timeOfDay and forward the text
      to the controller.
    */
    if (pickedTime != null) {
      setState(() {
        _timeOfDay = pickedTime;
        _txtTime.text = pickedTime.format(context);
      });
    }
  }

  @override
  void dispose() {
    // release memory of the controllers
    _txtName.dispose();
    _txtDesc.dispose();
    _txtTime.dispose();
    super.dispose();
  }
}