import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:todo_app_teste/model/category.dart';
import 'package:todo_app_teste/model/task.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  @observable
  ObservableList<Category> categories = <Category>[].asObservable();

  @action
  void addTask({Category category, Task task}) {
    Category catAll = categories.firstWhere(
      (cat) => cat.text == 'All',
      orElse: () => null,
    );

    if (catAll == null) {
      catAll = Category(
        icon: MdiIcons.checkBoxMultipleOutline,
        color: Colors.blue,
        text: "All",
        tasks: <Task>[].asObservable(),
      );

      categories.add(catAll);
    }

    final categoryFromList = categories.firstWhere(
      (cat) => cat.id == category.id,
      orElse: () => null,
    );

    if (categoryFromList == null) {
      categories.add(category);
      category.tasks = [task].asObservable();
    } else {
      category.tasks.add(task);
    }

    catAll.tasks.add(task);
  }
}
