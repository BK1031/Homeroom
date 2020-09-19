import 'package:firebase/firebase.dart';

class User {
  String id = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String role = ""; // Student or Teacher
  String profilePic = "https://firebasestorage.googleapis.com/v0/b/homeroom-app.appspot.com/o/default-profile.jpg?alt=media&token=7bbaf35c-3b95-47a4-93cd-42940e183d36";

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