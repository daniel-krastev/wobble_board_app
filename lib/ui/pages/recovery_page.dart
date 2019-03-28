import 'package:flutter/material.dart';
import 'package:wobble_board/ui/widgets/exercise.dart';


/// User interface class for the Recovery page.
class RecoveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.125,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                      key: Key("back_arrow"),
                      alignment: Alignment.centerLeft,
                      iconSize: Theme.of(context).iconTheme.size,
                      padding: EdgeInsets.all(18.0),
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back)),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text('Recovery',
                        key: Key("page_title"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .body1
                                .color)),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Image.asset('assets/images/recovery.png', height: 60),
                  )),
                ],
              ),
            ),
            Exercise(false),
          ],
        ),
      ),
    );
  }
}
