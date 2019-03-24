import 'package:flutter/material.dart';

class CustomSelector extends StatefulWidget {
  final String value;
  final Function callback;

  CustomSelector(this.value, this.callback);

  @override
  _CustomSelectorState createState() => new _CustomSelectorState();
}

class _CustomSelectorState extends State<CustomSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              onPressed: () {
                // move back one exercise if not at the first one
                widget.callback(-1);
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 20,
              )),
          // this updates every time the currentEx index is changed
          Text('${widget.value}',
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.body1.color,
                  fontSize: 20)),
          IconButton(
              onPressed: () {
                // move to the next exercise if not at the last one
                widget.callback(1);
              },
              icon: Icon(
                Icons.keyboard_arrow_right,
                size: 20,
              ))
        ]);
  }
}
