import 'package:mobx/mobx.dart';
import 'package:todo_app_teste/model/category.dart';
part 'task.g.dart';

class Task = _TaskBase with _$Task;

abstract class _TaskBase with Store {
  @observable
  int id;
  @observable
  String text;
  @observable
  bool done;
  @observable
  DateTime date;
  @observable
  DateTime time;
  @observable
  String note;
  @observable
  Category category;

  _TaskBase({
    this.text: "",
    this.done: false,
    this.date,
    this.time,
    this.note,
    this.category,
  }) : id = DateTime.now().millisecondsSinceEpoch;

  @action
  void setDone(bool isDone) {
    done = isDone;
  }

  @action
  void setText(String text) {
    this.text = text;
  }

  @action
  void setNote(String note) {
    this.note = note;
  }

  @computed
  DateTime get completeDate {
    DateTime completeDate = date;
    if (time != null) {
      completeDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    }

    return completeDate;
  }
}
