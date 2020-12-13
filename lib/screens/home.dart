import 'package:flutter/material.dart';
import 'package:todo_app_teste/config/routes.dart';
import '../widgets/category_card.dart';
import '../model/category.dart';
import '../model/task.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Home extends StatelessWidget {
  static Task task1 = Task(
    text: "Estudar Flutter",
    date: DateTime(2020, 12, 12),
  );
  static Task task2 = Task(
    text: "Malhar",
    date: DateTime(2020, 12, 13),
    done: true,
  );
  static Task task3 = Task(
    text: "Correr 5k",
    date: DateTime(2020, 12, 14),
    time: DateTime(2020, 12, 14, 7),
  );
  static Task task4 = Task(
    text: "Estudar Inglês",
  );
  static Task task5 = Task(
    text: "Reunião importante",
    date: DateTime(2020, 12, 13),
    time: DateTime(2020, 12, 13, 20),
  );

  final categories = [
    Category(
      icon: MdiIcons.checkBoxMultipleOutline,
      color: Colors.blue,
      text: "All",
      tasks: [
        task1,
        task2,
        task3,
        task4,
        task5,
      ],
    ),
    Category(
      icon: MdiIcons.briefcaseOutline,
      color: Colors.orange,
      text: "Work",
      tasks: [task5],
    ),
    Category(
      icon: MdiIcons.headphones,
      color: Colors.red[300],
      text: "Music",
      tasks: [],
    ),
    Category(
      icon: MdiIcons.beach,
      color: Colors.green,
      text: "Travel",
      tasks: [],
    ),
    Category(
      icon: MdiIcons.bookOpenPageVariantOutline,
      color: Colors.purple,
      text: "Study",
      tasks: [task1, task4],
    ),
    Category(
      icon: MdiIcons.homeOutline,
      color: Colors.amber,
      text: "Home",
      tasks: [],
    ),
    Category(
      icon: MdiIcons.heartOutline,
      color: Colors.red,
      text: "Health",
      tasks: [task2, task3],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.subject,
            color: Colors.black,
            size: 35,
          ),
          onPressed: () {},
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Lists",
              style: Theme.of(context).textTheme.headline4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.fromLTRB(12, 16, 12, 20),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: categories
                  .map(
                    (category) => CategoryCard(
                      category: category,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          Routes.tasks,
                          arguments: category,
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => _onAdd(context),
      ),
    );
  }

  void _onAdd(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.addTask);
  }
}
