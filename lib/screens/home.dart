import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_teste/controller/home_controller.dart';
import '../widgets/category_card.dart';
import '../widgets/add_task_fab.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeController _controller = Provider.of<HomeController>(
      context,
      listen: false,
    );

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
            child: Observer(
              builder: (_) {
                return GridView.count(
                  padding: EdgeInsets.fromLTRB(12, 16, 12, 20),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: _controller.categories
                      .map(
                        (category) => CategoryCard(
                          category: category,
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
          Observer(
            builder: (_) {
              if (_controller.categories.isEmpty) {
                return Expanded(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Why don't you add some tasks? 🧐",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Container();
            },
          ),
        ],
      ),
      floatingActionButton: AddTaskFAB(),
    );
  }
}
