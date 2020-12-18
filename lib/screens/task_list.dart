import 'package:flutter/material.dart';
import 'package:todo_app_teste/model/category.dart';
import 'package:todo_app_teste/model/task.dart';
import 'package:todo_app_teste/widgets/task_tile.dart';
import 'package:todo_app_teste/widgets/add_task_fab.dart';

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

  List<Task> _withoutDate = [];
  List<Task> _late = [];
  List<Task> _today = [];
  List<Task> _next = [];
  List<Task> _done = [];

  @override
  void initState() {
    super.initState();

    _withoutDate = _getWithoutDate(widget.category);
    _late = _getLate(widget.category);
    _today = _getToday(widget.category);
    _next = _getNext(widget.category);
    _done = _getDone(widget.category);
  }

  List<Task> _getWithoutDate(Category category) {
    final withoutDateTasks = category.tasks
        .where((task) => !task.done && task.date == null && task.time == null)
        .toList();

    return withoutDateTasks;
  }

  List<Task> _getLate(Category category) {
    final lateTasks = category.tasks.where(
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

  List<Task> _getToday(Category category) {
    final todayTasks = category.tasks.where(
      (task) {
        if (task.done || task.date == null) {
          return false;
        }

        return task.date.compareTo(_baseDate) == 0;
      },
    ).toList();

    return todayTasks;
  }

  List<Task> _getNext(Category category) {
    final nextTasks = category.tasks.where(
      (task) {
        if (task.done || task.date == null) {
          return false;
        }

        return task.date.compareTo(_baseDate) > 0;
      },
    ).toList();

    return nextTasks;
  }

  List<Task> _getDone(Category category) {
    final doneTasks = category.tasks.where((task) => task.done).toList();
    return doneTasks;
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
      body: widget.category == null
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
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
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 5.0),
                        child: Text(
                          widget.category.taskCountText,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.white70,
                              ),
                        ),
                      )
                    ],
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
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(32, 12, 32, 50),
                      children: [
                        if (widget.category.taskCount == 0)
                          Center(
                            child: Text(
                              "all done 🙌",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.grey),
                            ),
                          ),
                        ..._buildListWithTitle(
                          title: "Late",
                          tasks: _late,
                          late: true,
                        ),
                        ..._buildListWithTitle(title: "Today", tasks: _today),
                        ..._buildListWithTitle(tasks: _withoutDate),
                        ..._buildListWithTitle(title: "Next", tasks: _next),
                        ..._buildListWithTitle(
                          title: "Done",
                          tasks: _done,
                          done: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
