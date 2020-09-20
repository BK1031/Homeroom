import 'package:firebase/firebase.dart' as fb;
import 'package:homeroom_flutter/models/user.dart';

class ChatMessage {
  String key = "";
  String message = "";
  String mediaType = "";
  DateTime date = new DateTime.now();
  User author = new User();

  ChatMessage.plain();

  ChatMessage.fromSnapshot(fb.DataSnapshot snapshot) {
    key = snapshot.key;
    message = snapshot.val()["message"];
    author.id = snapshot.val()["author"];
    mediaType = snapshot.val()["type"];
    date = DateTime.parse(snapshot.val()["date"]);
  }
}