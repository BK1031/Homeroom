import 'package:firebase/firebase.dart';

class Classroom {
  String id = "";
  String name = "";
  String teacher = "";
  String section = "";

  Classroom();

  Classroom.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    name = snapshot.val()["name"];
    teacher = snapshot.val()["teacher"];
    section = snapshot.val()["section"];
  }

}