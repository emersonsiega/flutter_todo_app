import 'package:flutter/material.dart';
import 'package:todo_app_teste/model/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final Function onTap;

  const CategoryCard({
    Key key,
    @required this.category,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 40,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    category.text,
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      category.taskCountText,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                          ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
