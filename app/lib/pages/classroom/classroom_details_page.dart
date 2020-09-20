import 'package:flutter/material.dart';
import 'package:homeroom_flutter/pages/classroom/classroom_game.dart';

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
    ClassroomGame game = ClassroomGame();
    return Scaffold(
      body: game.widget,
    );
  }
}
