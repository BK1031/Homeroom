import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:homeroom_flutter/pages/rooms/room_game.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:homeroom_flutter/utils/theme.dart';
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
  String src = "/Users/bharat/Documents/Projects/Dev Projects/Flutter Apps/homeroom/web/room.html";
  _RoomPageState(this.id);

  @override
  Widget build(BuildContext context) {
    ClassroomGame game = ClassroomGame(id);
    return new Scaffold(
      backgroundColor: currBackgroundColor,
      body: new Container(
        color: currBackgroundColor,
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: new ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: EasyWebView(
                          src: src,
                          onLoaded: () {
                            print('$key: Loaded: $src');
                          },
                          key: key
                        // width: 100,
                        // height: 100,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
