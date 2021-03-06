import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_teste/controller/home_controller.dart';
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
  HomeController _controller;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _controller = Provider.of<HomeController>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        actions: <Widget>[
          _markAllDoneAction(),
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
                          child: Row(
                            children: [
                              AnimatedSwitcher(
                                duration: Duration(milliseconds: 500),
                                child: Align(
                                  key: Key(widget.category.taskCountText),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${widget.category.taskCount}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white70,
                                        ),
                                  ),
                                ),
                              ),
                              Text(
                                " ${widget.category.taskSizeDescriptionText}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white70,
                                    ),
                              ),
                            ],
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
        category: !widget.category.isMock ? widget.category : null,
      ),
    );
  }

  Widget _markAllDoneAction() {
    return Observer(
      builder: (BuildContext context) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: (widget.category.taskCount > 0)
              ? PopupMenuButton(
                  offset: Offset(0, 45),
                  onSelected: (_) => _onCompleteAll(),
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
                        value: true,
                      ),
                    ];
                  },
                )
              : Container(),
        );
      },
    );
  }

  void _onCompleteAll() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(
          "Are you sure?",
          style: Theme.of(context).textTheme.headline6,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text("You really want to complete all tasks?"),
            ),
          ],
        ),
        actions: [
          FlatButton(
            child: Text(
              "No, wait!",
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          RaisedButton(
            child: Text("Yes"),
            color: Colors.blue,
            onPressed: () {
              Navigator.of(context).pop();
              widget.category.setAllDone();
            },
          )
        ],
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
          .map(
            (task) => Opacity(
              opacity: opacity,
              child: TaskTile(
                task: task,
                needAttention: late,
                category: widget.category,
                onRemove: _onRemoveTask,
              ),
            ),
          )
          .toList(),
      if (tasks.length > 0 && title != null)
        Padding(
          padding: EdgeInsets.only(bottom: 10),
        ),
    ];
  }

  void _onRemoveTask(Task task) {
    _controller.removeTask(task);
  }
}
