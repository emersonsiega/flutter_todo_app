import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_teste/controller/home_controller.dart';
import 'package:todo_app_teste/model/task.dart';
import 'package:todo_app_teste/widgets/category_creation.dart';
import 'package:todo_app_teste/widgets/category_picker.dart';
import '../widgets/task_info_tile.dart';
import '../model/category.dart';

class AddTask extends StatefulWidget {
  final Category category;

  const AddTask({Key key, this.category}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();

  HomeController _controller;
  Task task = Task();
  Category _category;
  bool _isCategoryValid = true;

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
                      onChanged: task.setText,
                      validator: _textValidator,
                    ),
                    TaskInfoTile(
                      text: "Add alert",
                      onTap: () {},
                      icon: MdiIcons.bellRingOutline,
                    ),
                    TaskInfoTile(
                      text: "Add note",
                      onTap: () {},
                      icon: MdiIcons.noteOutline,
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

  void _onCreateTask() {
    if (_formKey.currentState.validate() & _validateCategory()) {
      _controller.addTask(category: _category, task: task);
      Navigator.of(context).pop();
    }
  }

  void _onSelectCategory() {
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
}
