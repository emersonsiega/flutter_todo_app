import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:todo_app_teste/model/category.dart';
import 'package:todo_app_teste/model/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final bool needAttention;
  final Category category;
  final void Function(Task) onRemove;

  const TaskTile({
    Key key,
    @required this.task,
    @required this.onRemove,
    this.needAttention: false,
    this.category,
  }) : super(key: key);

  String get _getFormat {
    if (task.date != null && task.time != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (task.date.isAtSameMomentAs(today)) {
        return 'HH:mm';
      }

      return 'HH:mm - MMM d';
    }

    return 'MMM d';
  }

  String get completeDate {
    return DateFormat(_getFormat).format(task.completeDate);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key("${task.id}"),
      dismissThresholds: {
        DismissDirection.endToStart: 0.4,
      },
      onDismissed: (_) {
        onRemove(task);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0, left: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Release to delete",
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Colors.white,
                      ),
                ),
                Icon(
                  MdiIcons.trashCanOutline,
                  color: Colors.white,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ),
      child: ListTileTheme(
        contentPadding: EdgeInsets.all(0),
        child: CheckboxListTile(
          value: task.done,
          onChanged: task.setDone,
          controlAffinity: ListTileControlAffinity.trailing,
          title: Text(
            task.text,
            style: task.done
                ? Theme.of(context).textTheme.headline6.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.blue[200],
                    )
                : Theme.of(context).textTheme.headline6,
          ),
          isThreeLine: task.note != null && task.completeDate != null,
          secondary: category != null && category.isMock
              ? Opacity(
                  opacity: task.done ? 0.6 : 1.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      task.category.icon,
                      color: task.category.color,
                      size: 30,
                    ),
                  ),
                )
              : null,
          subtitle: Builder(
            builder: (_) {
              String text = "";
              if (task.completeDate != null) {
                text = completeDate;
              }

              if (task.note != null) {
                if (text.isNotEmpty) {
                  text = "$text\n";
                }

                text = "$text${task.note}";
              }

              if (text.isEmpty) {
                return Container();
              }

              return Text(
                text,
                style: task.done
                    ? Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Colors.grey[400],
                        )
                    : Theme.of(context).textTheme.subtitle1.copyWith(
                          color: needAttention ? Colors.red : Colors.grey[700],
                        ),
              );
            },
          ),
        ),
      ),
    );
  }
}
