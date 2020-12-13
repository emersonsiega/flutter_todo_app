import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../widgets/task_info_tile.dart';
import '../model/category.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _forkKey = GlobalKey<FormState>();
  Category _category;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _getCategory);
  }

  void _getCategory() {
    Category category = ModalRoute.of(context).settings.arguments;

    if (category != null) {
      setState(() {
        _category = category;
      });
    }
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
            key: _forkKey,
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
                      onTap: () {},
                      icon: MdiIcons.tagOutline,
                      selected: _category != null,
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
          onPressed: () {},
        ),
      ),
    );
  }
}
