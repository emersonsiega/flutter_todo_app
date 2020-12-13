import 'package:flutter/material.dart';

class TaskInfoTile extends StatelessWidget {
  final String text;
  final Function onTap;
  final IconData icon;
  final bool selected;

  TaskInfoTile({
    @required this.text,
    @required this.onTap,
    @required this.icon,
    this.selected: false,
  });

  @override
  Widget build(BuildContext context) {
    Color _color = selected ? Colors.blue : Colors.grey;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: _color,
              size: 30,
            ),
            SizedBox(width: 20),
            Text(
              text,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: _color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
