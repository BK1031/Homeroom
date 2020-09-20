import 'package:flutter/material.dart';

class ClassroomDetailsPage extends StatefulWidget {
  String id;
  ClassroomDetailsPage(this.id);
  @override
  _ClassroomDetailsPageState createState() => _ClassroomDetailsPageState(this.id);
}

class _ClassroomDetailsPageState extends State<ClassroomDetailsPage> {
  String id;

  _ClassroomDetailsPageState(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}
