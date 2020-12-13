import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/task_list.dart';
import '../screens/add_task.dart';

class Routes {
  static const String home = '/';
  static const String tasks = '/tasks';
  static const String addTask = '/tasks/add';

  static Map<String, WidgetBuilder> buildRoutes() {
    return {
      home: (_) => Home(),
      tasks: (_) => TaskList(),
      addTask: (_) => AddTask(),
    };
  }
}
