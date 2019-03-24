import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final double time;
  final Function callback;

  CustomDialog(this.time, this.callback);

  @override
  _CustomDialogState createState() => new _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  final formKey = GlobalKey<FormState>();
  String _value;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 200.0,
        width: 250.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Total time: ${widget.time}s',
              style: TextStyle(
                  color: Theme.of(context).primaryColorLight, fontSize: 20),
            ),
            Container(
              width: 140.0,
              height: 80.0,
              child: Form(
                key: formKey,
                child: TextFormField(
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight, fontSize: 20),
                  decoration: InputDecoration(
                    labelText: 'Kent Login',
                  ),
                  validator: (val) => val.isEmpty ? 'required field' : null,
                  onSaved: (val) => _value = val,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop('dialog');
                    widget.callback();
                  },
                  child: Text('Cancel',
                      style: Theme.of(context).primaryTextTheme.button),
                ),
                RaisedButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      widget.callback(_value);
                      Navigator.of(context).pop('dialog');
                    }
                  },
                  child: Text('Submit',
                      style: Theme.of(context).primaryTextTheme.button),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
