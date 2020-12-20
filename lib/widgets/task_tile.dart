import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_teste/model/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final bool needAttention;

  const TaskTile({
    Key key,
    @required this.task,
    this.needAttention: false,
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
    return ListTileTheme(
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
        subtitle: Builder(
          builder: (_) {
            if (task.completeDate == null) {
              return Container();
            }

            return Text(
              completeDate,
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
    );
  }
}
