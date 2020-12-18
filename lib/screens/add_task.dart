import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../widgets/task_info_tile.dart';
import '../model/category.dart';

class AddTask extends StatefulWidget {
  final Category category;

  const AddTask({Key key, this.category}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _forkKey = GlobalKey<FormState>();

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
                      text: widget.category == null
                          ? "Category"
                          : widget.category.text,
                      onTap: () {},
                      icon: MdiIcons.tagOutline,
                      selected: widget.category != null,
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
