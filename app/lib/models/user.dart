import 'package:firebase/firebase.dart';

class User {
  String id = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String role = ""; // Student or Teacher

  User.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    firstName = snapshot.val()["firstName"];
    lastName = snapshot.val()["lastName"];
    email = snapshot.val()["email"];
    role = snapshot.val()["role"];
  }
}