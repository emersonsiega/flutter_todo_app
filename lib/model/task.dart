class Task {
  int id;
  String text;
  bool done;
  DateTime date;
  DateTime time;
  String note;

  Task({
    this.text,
    this.done: false,
    this.date,
    this.time,
    this.note,
  }) : id = DateTime.now().millisecondsSinceEpoch;

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
