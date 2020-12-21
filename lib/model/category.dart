import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import './task.dart';

part 'category.g.dart';

class Category = _CategoryBase with _$Category;

abstract class _CategoryBase with Store {
  @observable
  int id;
  @observable
  String text;
  @observable
  Color color;
  @observable
  IconData icon;
  @observable
  ObservableList<Task> tasks;

  _CategoryBase({
    this.text,
    this.color,
    this.icon,
    this.tasks,
  }) : id = DateTime.now().millisecondsSinceEpoch;

  final _baseDateHour = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
  );
  final _baseDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @computed
  int get taskCount => tasks.where((task) => !task.done).length;

  @computed
  String get taskCountText => "$taskCount Task${taskCount != 1 ? 's' : ''}";

  @computed
  String get taskSizeDescriptionText => "Task${taskCount != 1 ? 's' : ''}";

  @computed
  List<Task> get getWithoutDate {
    final withoutDateTasks = tasks
        .where((task) => !task.done && task.date == null && task.time == null)
        .toList();

    return withoutDateTasks;
  }

  @computed
  List<Task> get getLate {
    final lateTasks = tasks.where(
      (task) {
        if (task.done || (task.date == null && task.time == null)) {
          return false;
        }

        if (task.time == null) {
          return task.date.isBefore(_baseDate);
        }

        return task.completeDate.isBefore(_baseDateHour);
      },
    ).toList();

    return lateTasks;
  }

  @computed
  List<Task> get getToday {
    final todayTasks = tasks.where(
      (task) {
        if (task.done || task.date == null) {
          return false;
        }

        return task.date.compareTo(_baseDate) == 0;
      },
    ).toList();

    return todayTasks;
  }

  @computed
  List<Task> get getNext {
    final nextTasks = tasks.where(
      (task) {
        if (task.done || task.date == null) {
          return false;
        }

        return task.date.compareTo(_baseDate) > 0;
      },
    ).toList();

    return nextTasks;
  }

  @computed
  List<Task> get getDone {
    final doneTasks = tasks.where((task) => task.done).toList();
    return doneTasks;
  }

  @action
  void setText(String text) {
    this.text = text;
  }

  @action
  void setAllDone() {
    List<Task> doneTasks = tasks.map((task) {
      task.setDone(true);
      return task;
    }).toList();
    tasks = doneTasks.asObservable();
  }
}
