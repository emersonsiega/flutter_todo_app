import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:todo_app_teste/model/category.dart';
import 'package:todo_app_teste/model/task.dart';
import 'package:todo_app_teste/widgets/add_task_fab.dart';
import 'package:todo_app_teste/widgets/task_tile.dart';

class TaskList extends StatefulWidget {
  final Category category;

  const TaskList({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        actions: <Widget>[
          PopupMenuButton(
            offset: Offset(0, 45),
            onSelected: (vl) {
              //TODO ...
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("Mark all done"),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.check_box,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (widget.category == null) {
            return Container();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Observer(
                  builder: (_) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Icon(
                                widget.category.icon,
                                color: widget.category.color,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            widget.category.text,
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 5.0),
                          child: Text(
                            widget.category.taskCountText,
                            style:
                                Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white70,
                                    ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Observer(
                    builder: (_) {
                      return ListView(
                        padding: const EdgeInsets.fromLTRB(32, 12, 32, 50),
                        children: [
                          if (widget.category.taskCount == 0)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Center(
                                child: Text(
                                  "All done 🙌",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: Colors.grey),
                                ),
                              ),
                            ),
                          ..._buildListWithTitle(
                            title: "Late",
                            tasks: widget.category.getLate,
                            late: true,
                          ),
                          ..._buildListWithTitle(
                            title: "Today",
                            tasks: widget.category.getToday,
                          ),
                          ..._buildListWithTitle(
                            tasks: widget.category.getWithoutDate,
                          ),
                          ..._buildListWithTitle(
                              title: "Next", tasks: widget.category.getNext),
                          ..._buildListWithTitle(
                            title: "Done",
                            tasks: widget.category.getDone,
                            done: true,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: AddTaskFAB(
        category: widget.category.text != "All" ? widget.category : null,
      ),
    );
  }

  List<Widget> _buildListWithTitle({
    String title,
    List<Task> tasks,
    bool late = false,
    bool done = false,
  }) {
    final opacity = done ? 0.8 : 1.0;
    return [
      if (tasks.length > 0 && title != null)
        Opacity(
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
        ),
      ...tasks
          .map((task) => Opacity(
                opacity: opacity,
                child: TaskTile(
                  task: task,
                  needAttention: late,
                ),
              ))
          .toList(),
      if (tasks.length > 0 && title != null)
        Padding(
          padding: EdgeInsets.only(bottom: 10),
        ),
    ];
  }
}
