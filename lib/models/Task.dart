import 'package:flutter/material.dart';
import '../util/DayOfWeek.dart';
import 'dart:convert';

class Task{
  int? id;
  String name;
  String desc;
  TimeOfDay time;
  List<DayOfWeek> days = List.empty(growable: true);

  Task(this.id, this.name, this.desc, this.time, this.days);

  Map<String, dynamic> toMap() {
    return {
      "id" : id == 0 ? null : id,
      "name" : name,
      "desc" : desc,
      "time" : time,
      "days" : jsonEncode(days.map((d) => d.name).toList())
    };
  }
}