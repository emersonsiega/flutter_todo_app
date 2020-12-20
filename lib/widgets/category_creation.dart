import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:todo_app_teste/model/category.dart';

class CategoryCreation extends StatefulWidget {
  final void Function(Category) onCreateCategory;

  const CategoryCreation({
    Key key,
    @required this.onCreateCategory,
  }) : super(key: key);

  @override
  _CategoryCreationState createState() => _CategoryCreationState();
}

class _CategoryCreationState extends State<CategoryCreation> {
  final _formKey = GlobalKey<FormState>();
  Category _category = Category();
  bool _isIconValid = true;
  bool _isColorValid = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: "Category name",
                  counterStyle: Theme.of(context).textTheme.caption.copyWith(
                        color: Colors.white70,
                      ),
                  labelStyle: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white,
                      ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                cursorColor: Colors.white30,
                maxLength: 30,
                onChanged: _category.setText,
                validator: _textValidator,
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    width: 60,
                    height: 60,
                    child: Icon(
                      _category?.icon ?? MdiIcons.help,
                      color: _category?.color ?? Colors.grey,
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 20),
                  OutlineButton(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                        color: _isIconValid ? Colors.white : Colors.red,
                      ),
                      child: Text("Select icon"),
                    ),
                    onPressed: _pickIcon,
                  ),
                  SizedBox(width: 20),
                  OutlineButton(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: TextStyle(
                        color: _isColorValid ? Colors.white : Colors.red,
                      ),
                      child: Text("Select color"),
                    ),
                    onPressed: _pickColor,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 5 + MediaQuery.of(context).padding.bottom,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: RaisedButton(
                    onPressed: _onSave,
                    child: Text(
                      "Add category",
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.blue,
                          ),
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _textValidator(String value) {
    if (value.isEmpty) {
      return "Category name must be provided";
    }

    return null;
  }

  bool _validateIcon() {
    _isIconValid = _category.icon != null;

    setState(() {});

    return _isIconValid;
  }

  bool _validateColor() {
    _isColorValid = _category.color != null;

    setState(() {});

    return _isColorValid;
  }

  void _onSave() {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_formKey.currentState.validate() & _validateIcon() & _validateColor()) {
      widget.onCreateCategory(_category);

      Navigator.of(context).pop();
    }
  }

  void _pickIcon() async {
    FocusScope.of(context).requestFocus(FocusNode());

    IconData icon = await FlutterIconPicker.showIconPicker(
      context,
      iconPackMode: IconPack.materialOutline,
      adaptiveDialog: true,
    );

    setState(() {
      _category.icon = icon;
      Future.delayed(Duration.zero, _validateIcon);
    });
  }

  void _onChangeColor(Color color) {
    setState(() {
      _category.color = color;
      Future.delayed(Duration.zero, _validateColor);
    });
  }

  void _pickColor() {
    FocusScope.of(context).requestFocus(FocusNode());

    showDialog(
      context: context,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        title: Text("Select color"),
        content: MaterialColorPicker(
          onlyShadeSelection: true,
          circleSize: 60,
          spacing: 10,
          onMainColorChange: _onChangeColor,
          onColorChange: _onChangeColor,
          selectedColor: _category.color,
          elevation: 4,
          shrinkWrap: true,
        ),
        contentPadding: const EdgeInsets.all(6.0),
        actions: [
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              _onChangeColor(null);
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Select"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
