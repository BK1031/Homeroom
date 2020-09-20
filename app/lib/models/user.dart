import 'package:firebase/firebase.dart';

class User {
  String id = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String role = ""; // Student or Teacher
  String profilePic = "https://firebasestorage.googleapis.com/v0/b/homeroom-app.appspot.com/o/default-profile-1.png?alt=media&token=c4e7902e-d9ef-47e4-9aa5-4b21bbc4190e";

  User();

  User.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    firstName = snapshot.val()["firstName"];
    lastName = snapshot.val()["lastName"];
    email = snapshot.val()["email"];
    role = snapshot.val()["role"];
    profilePic = snapshot.val()["profilePic"];
  }
}