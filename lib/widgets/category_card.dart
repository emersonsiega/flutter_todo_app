import 'package:flutter/material.dart';
import 'package:todo_app_teste/model/category.dart';
import 'package:animations/animations.dart';
import '../screens/task_list.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openColor: Colors.white,
      closedElevation: 4.0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      closedColor: Colors.white,
      transitionDuration: Duration(milliseconds: 400),
      closedBuilder: (context, open) {
        return GestureDetector(
          onTap: open,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 40,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        category.text,
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          "${category.taskCountText}",
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      openBuilder: (BuildContext context, closeContainer) {
        return TaskList(
          category: category,
        );
      },
    );
  }
}
