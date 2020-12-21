import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_teste/config/theme_builder.dart';
import 'package:todo_app_teste/controller/home_controller.dart';
import 'package:todo_app_teste/model/task.dart';
import 'package:todo_app_teste/widgets/category_creation.dart';
import 'package:todo_app_teste/widgets/category_picker.dart';

import '../model/category.dart';
import '../widgets/task_info_tile.dart';

class AddTask extends StatefulWidget {
  final Category category;

  const AddTask({Key key, this.category}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();

  HomeController _controller;
  Task _task = Task();
  Category _category;
  bool _isCategoryValid = true;
  bool _isDateTimeValid = true;

  @override
  void initState() {
    super.initState();
    _category = widget.category;

    Future.delayed(Duration.zero, () {
      _controller = Provider.of<HomeController>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text(
          "New task",
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "What are you planning?",
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 20),
                        helperText: " ",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        isDense: true,
                      ),
                      style: Theme.of(context).textTheme.headline5,
                      cursorColor: Colors.blue,
                      textInputAction: TextInputAction.done,
                      minLines: 1,
                      maxLines: 3,
                      onChanged: _task.setText,
                      validator: _textValidator,
                    ),
                    TaskInfoTile(
                      text: _task.date == null
                          ? "Add alert"
                          : DateFormat("d/MM/yyyy").format(_task.date),
                      onTap: _onAddAlert,
                      selected: _task.date != null,
                      icon: MdiIcons.bellRingOutline,
                      isValid: _isDateTimeValid,
                      onRemove: () {
                        setState(() {
                          _task.date = null;
                          _task.time = null;
                          _isDateTimeValid = true;
                        });
                      },
                    ),
                    AnimatedCrossFade(
                      crossFadeState: _task.date == null
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 200),
                      firstChild: Container(),
                      secondChild: TaskInfoTile(
                        text: _task.time == null
                            ? "Add hour"
                            : DateFormat("HH:mm").format(_task.time),
                        selected: _task.time != null,
                        onTap: _onAddHour,
                        icon: MdiIcons.clockOutline,
                        isValid: _isDateTimeValid,
                        onRemove: () {
                          setState(() {
                            _task.time = null;
                            _isDateTimeValid = true;
                          });
                        },
                      ),
                    ),
                    TaskInfoTile(
                      text: _task.note == null ? "Add note" : _task.note,
                      onTap: _onAddNote,
                      icon: MdiIcons.noteOutline,
                      selected: _task.note?.isNotEmpty == true,
                      onRemove: _onRemoveNote,
                    ),
                    TaskInfoTile(
                      text: _category == null ? "Category" : _category.text,
                      onTap: _onSelectCategory,
                      icon: MdiIcons.tagOutline,
                      selected: _category != null,
                      isValid: _isCategoryValid,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50 + MediaQuery.of(context).padding.bottom,
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            "Create",
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: Colors.white,
                ),
          ),
          onPressed: _onCreateTask,
        ),
      ),
    );
  }

  void _removeFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  String _textValidator(String value) {
    if (value.isEmpty) {
      return "What are you planning?";
    }

    return null;
  }

  bool _validateCategory() {
    _isCategoryValid = _category != null;

    setState(() {});

    return _isCategoryValid;
  }

  bool _validateDateTime() {
    if (_task.date != null && _task.time != null) {
      _isDateTimeValid = _task.completeDate.isAfter(DateTime.now());
    } else if (_task.date != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      _isDateTimeValid = _task.date.compareTo(today) >= 0;
    }

    setState(() {});

    return _isDateTimeValid;
  }

  void _onCreateTask() {
    if (_formKey.currentState.validate() &
        _validateCategory() &
        _validateDateTime()) {
      _controller.addTask(category: _category, task: _task);
      Navigator.of(context).pop();
    }
  }

  void _onSelectCategory() {
    _removeFocus();

    if (_controller.categories.isEmpty && _category == null) {
      return _onCreateCategory();
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CategoryPicker(
          initialItem: _category,
          onSelectedItemChanged: (Category category) {
            setState(() {
              _category = category;
            });
          },
          onCreateCategory: _onCreateCategory,
        );
      },
    );
  }

  void _onCreateCategory() {
    setState(() {
      _category = null;
    });

    Future.delayed(
      Duration(milliseconds: 200),
      () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: CategoryCreation(
                onCreateCategory: (Category newCategory) {
                  setState(() {
                    _category = newCategory;
                    _isCategoryValid = true;
                  });
                },
              ),
            );
          },
        );
      },
    );
  }

  void _onAddAlert() {
    _removeFocus();

    final now = DateTime.now();
    final minimumDate = DateTime(now.year, now.month, now.day);
    setState(() {
      _task.date = now;
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: ThemeBuilder.cupertinoTheme(
            context: context,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              backgroundColor: Theme.of(context).primaryColor,
              minimumDate: minimumDate,
              initialDateTime: _task.date,
              use24hFormat: true,
              onDateTimeChanged: (DateTime value) {
                setState(() {
                  _task.date = value;
                  _isDateTimeValid = true;
                });
              },
            ),
          ),
        );
      },
    );
  }

  bool _isToday() {
    final today = DateTime.now();

    return _task.date.year == today.year &&
        _task.date.month == today.month &&
        _task.date.day == today.day;
  }

  void _onAddHour() {
    _removeFocus();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: ThemeBuilder.cupertinoTheme(
            context: context,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              backgroundColor: Theme.of(context).primaryColor,
              minimumDate: _isToday() ? DateTime.now() : null,
              initialDateTime: _task.time,
              use24hFormat: true,
              onDateTimeChanged: (DateTime value) {
                setState(() {
                  _task.time = value;
                  _isDateTimeValid = true;
                });
              },
            ),
          ),
        );
      },
    );
  }

  void _onAddNote() {
    _removeFocus();
    final _textController = TextEditingController(text: _task.note);

    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Add note"),
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Important notes",
                  alignLabelWithHint: true,
                ),
                controller: _textController,
                minLines: 1,
                maxLines: 1,
                maxLength: 30,
              ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              "Clear",
            ),
            onPressed: () {
              setState(() {
                _task.setNote(null);
              });
              Navigator.of(context).pop();
            },
          ),
          RaisedButton(
            child: Text("Add"),
            color: Colors.blue,
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                setState(() {
                  _task.setNote(_textController.text);
                });
              }

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _onRemoveNote() {
    setState(() {
      _task.setNote(null);
    });
  }
}
