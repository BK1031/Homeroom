import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:homeroom_flutter/pages/classroom/classroom_chat_page.dart';
import 'package:homeroom_flutter/pages/rooms/room_game.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:homeroom_flutter/utils/config.dart';
import 'package:homeroom_flutter/utils/theme.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:webview_flutter/webview_flutter.dart';

class RoomPage extends StatefulWidget {
  String id;
  RoomPage(this.id);
  @override
  _RoomPageState createState() => _RoomPageState(this.id);
}

class _RoomPageState extends State<RoomPage> {
  String id;
  static ValueKey key = ValueKey('key_0');
  String src = "https://flutter.dev";
  _RoomPageState(this.id);

  @override
  void initState() {
    super.initState();
    fb.database().ref("rooms").child(id).child("users").child(currUser.id).set({
      "audio": false,
      "video": true
    });
    setState(() {
      src = "/Users/bharat/Documents/Projects/Dev Projects/Flutter Apps/homeroom/web/room.html#${currUser.id}#$id";
    });
  }

  @override
  Widget build(BuildContext context) {
    ClassroomGame game = ClassroomGame(id);
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      body: new Container(
        height: MediaQuery.of(context).size.height,
        color: currBackgroundColor,
        child: new Row(
          children: [
            new Expanded(
              child: Container(
                child: new Column(
                  children: [
                    new ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: new Container(
                        height: 200,
                        width: double.maxFinite,
                        color: Colors.black,
                        child: Stack(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: EasyWebView(
                                      src: src,
                                      onLoaded: () {
                                        print('$key: Loaded: $src');
                                      },
                                      key: key
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    new Container(
                      color: Colors.lightGreenAccent,
                      child: new Text("game goes here"),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 300,
              child: new Column(
                children: [
                  new Expanded(
                    child: new ClassroomChatPage(id),
                  ),
                  new Container(
                    child: new Column(
                      children: [
                        new Text("controls or smth go here")
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
