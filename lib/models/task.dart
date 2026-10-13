import 'package:flutter/material.dart';
import 'day_of_week.dart';

class Task{
  int? id;
  String name;
  String desc;
  TimeOfDay time;
  List<DayOfWeek> days = List.empty(growable: true);

  Task(
    {this.id, required this.name, required this.desc, required this.time, required this.days});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'] as int?,
        name: map['name'] as String,
        desc: map['desc'] as String,
        time: map['time'] as TimeOfDay,
        days: map['days'] as List<DayOfWeek>
      );
    }

  Map<String, dynamic> toMap() {
    return {
      "id" : id == 0 ? null : id,
      "name" : name,
      "desc" : desc,
      "time" : time,
      "days" : days
    };
  }
}