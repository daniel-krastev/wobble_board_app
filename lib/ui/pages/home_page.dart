import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _HomeState();
  CollectionReference leaderboard =
      Firestore.instance.collection('leaderboard');
  @override
  Widget build(BuildContext context) {
    leaderboard.snapshots().listen(
        (data) => data.documents.forEach((doc) => print(doc['firstname'])));
    leaderboard.document().setData({'firstname': 'работи', 'time': 4343.333});
    return Text('kur');
  }
}
