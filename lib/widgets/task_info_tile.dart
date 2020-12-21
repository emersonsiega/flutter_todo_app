import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TaskInfoTile extends StatelessWidget {
  final String text;
  final Function onTap;
  final IconData icon;
  final bool selected;
  final bool isValid;
  final void Function() onRemove;

  TaskInfoTile({
    @required this.text,
    @required this.onTap,
    @required this.icon,
    this.selected: false,
    this.isValid: true,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    Color _color = selected ? Colors.blue : Colors.grey;
    if (!isValid) {
      _color = Colors.redAccent;
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: _color,
              size: 30,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: _color,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IgnorePointer(
              ignoring: !selected || onRemove == null,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 250),
                opacity: selected && onRemove != null ? 1.0 : 0.0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 30,
                    width: 30,
                    child: Icon(
                      MdiIcons.trashCanOutline,
                      color: Colors.red,
                      size: 25,
                    ),
                  ),
                  onTap: onRemove,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
