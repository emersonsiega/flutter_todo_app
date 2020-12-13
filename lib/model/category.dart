import 'package:flutter/material.dart';
import './task.dart';

class Category {
  int id;
  String text;
  Color color;
  IconData icon;
  List<Task> _tasks;

  Category({
    this.text,
    this.color,
    this.icon,
    List<Task> tasks: const [],
  })  : id = DateTime.now().millisecondsSinceEpoch,
        _tasks = tasks;

  int get taskCount => _tasks.length;
  String get taskCountText => "$taskCount Task${taskCount != 1 ? 's' : ''}";

  List<Task> get tasks {
    _tasks.sort(
      (taskA, taskB) {
        if (taskA.date == null && taskB.date == null) {
          return 0;
        }

        if (taskA.date == null) {
          return -1;
        }

        if (taskB.date == null) {
          return 1;
        }

        return taskA.completeDate.compareTo(taskB.completeDate);
      },
    );

    return _tasks;
  }
}
