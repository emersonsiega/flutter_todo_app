import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:todo_app_teste/model/category.dart';

import '../screens/add_task.dart';

class AddTaskFAB extends StatelessWidget {
  final Category category;

  const AddTaskFAB({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedBuilder: (context, onOpen) {
        return FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          elevation: 0,
          onPressed: onOpen,
        );
      },
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      transitionDuration: Duration(milliseconds: 400),
      closedElevation: 4.0,
      closedColor: Colors.blue,
      openColor: Colors.white,
      openBuilder: (context, onClose) {
        return AddTask(category: category);
      },
    );
  }
}
