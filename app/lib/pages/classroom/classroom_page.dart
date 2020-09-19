import 'package:flutter/material.dart';

class ClassroomPage extends StatefulWidget {
  String id;
  ClassroomPage(this.id);
  @override
  _ClassroomPageState createState() => _ClassroomPageState(this.id);
}

class _ClassroomPageState extends State<ClassroomPage> {
  String id;

  _ClassroomPageState(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
