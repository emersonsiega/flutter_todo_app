import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_teste/controller/home_controller.dart';
import 'package:todo_app_teste/model/category.dart';

class CategoryPicker extends StatefulWidget {
  final ValueChanged<Category> onSelectedItemChanged;
  final VoidCallback onCreateCategory;
  final Category initialItem;

  const CategoryPicker({
    Key key,
    @required this.onSelectedItemChanged,
    @required this.onCreateCategory,
    this.initialItem,
  }) : super(key: key);

  @override
  _CategoryPickerState createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  HomeController _controller;
  List<Category> _categories;
  FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _controller = Provider.of<HomeController>(context, listen: false);

      List<Category> categories =
          _controller.categories.where((cat) => cat.text != "All").toList();
      categories.sort((catA, catB) => catA.text.compareTo(catB.text));

      int initialIndex = 0;
      if (widget.initialItem != null) {
        initialIndex = categories.indexOf(widget.initialItem);
      }

      _scrollController = FixedExtentScrollController(
        initialItem: initialIndex,
      );

      setState(() {
        _categories = categories;
        if (widget.initialItem == null && categories.isNotEmpty) {
          widget.onSelectedItemChanged(categories.first);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_categories == null) {
      return Container();
    }

    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              scrollController: _scrollController,
              onSelectedItemChanged: (int index) {
                widget.onSelectedItemChanged(_categories[index]);
              },
              itemExtent: 50,
              magnification: 1.3,
              backgroundColor: Theme.of(context).primaryColor,
              children: _categories.map((category) {
                return Center(
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            category.icon,
                            color: category.color,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        LimitedBox(
                          maxWidth: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            "${category.text}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                "Add Category",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                widget.onCreateCategory();

                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
