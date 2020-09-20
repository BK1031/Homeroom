import 'package:flutter/material.dart';
import 'package:homeroom_flutter/pages/rooms/room_game.dart';

class RoomPage extends StatefulWidget {
  String id;
  RoomPage(this.id);
  @override
  _RoomPageState createState() => _RoomPageState(this.id);
}

class _RoomPageState extends State<RoomPage> {
  String id;

  _RoomPageState(this.id);

  @override
  Widget build(BuildContext context) {
    ClassroomGame game = ClassroomGame();
    return Scaffold(
      body: game.widget,
    );
  }
}
