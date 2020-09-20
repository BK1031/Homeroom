import 'package:easy_web_view/easy_web_view.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:homeroom_flutter/pages/classroom/classroom_chat_page.dart';
import 'package:homeroom_flutter/pages/rooms/room_game.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:homeroom_flutter/utils/config.dart';
import 'package:homeroom_flutter/utils/theme.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:url_launcher/url_launcher.dart';
import 'dart:js' as js;
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

  bool video = true;
  bool audio = true;
  bool screen = false;

  _RoomPageState(this.id);

  @override
  void initState() {
    super.initState();
    fb.database().ref("rooms").child(id).child("users").child(currUser.id).set({
      "audio": false,
      "video": true,
      "screen": false
    });
    setupRoomUrl();
  }

  setupRoomUrl() {
    js.context.callMethod("requestWebcamAudio");
    setState(() {
      src = "https://homeroom.bk1031.dev/room#${currUser.id}#$id";
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      headers: {"Feature-Policy": "microphone '*'; camera '*'"},
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
                    new Linkify(text: src, onOpen: (src) {
                      launch(src.url);
                    }),
                    new Expanded(
                      child: new Container(
                        width: double.maxFinite,
                        color: currBackgroundColor,
                        child: Center(child: game.widget),
                      ),
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
                    padding: EdgeInsets.all(8),
                    child: new Column(
                      children: [
                        new Text("Room Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        new Padding(padding: EdgeInsets.all(2)),
                        new Text("Join Code: $id", style: TextStyle(fontSize: 18, color: Colors.grey),),
                        new Padding(padding: EdgeInsets.all(2)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Expanded(
                              child: new Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: currCardColor,
                                child: new InkWell(
                                  onTap: () {
                                    setState(() {
                                      video = !video;
                                    });
                                    fb.database().ref("rooms").child(id).child("users").child(currUser.id).child("video").set(video);
                                  },
                                  child: new Container(
                                    height: 100,
                                    width: 100,
                                    padding: EdgeInsets.all(8),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        new Icon(video ? Icons.videocam : Icons.videocam_off, size: 50, color: Colors.grey,),
                                        new Text(video ? "Turn Off" : "Turn On", style: TextStyle(color: Colors.grey),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            new Padding(padding: EdgeInsets.all(4)),
                            new Expanded(
                              child: new Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                color: currCardColor,
                                child: new InkWell(
                                  onTap: () {
                                    setState(() {
                                      audio = !audio;
                                    });
                                    fb.database().ref("rooms").child(id).child("users").child(currUser.id).child("audio").set(audio);
                                  },
                                  child: new Container(
                                    height: 100,
                                    width: 100,
                                    padding: EdgeInsets.all(8),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        new Icon(audio ? Icons.mic : Icons.mic_off, size: 50, color: Colors.grey,),
                                        new Text(audio ? "Mute" : "Unmute", style: TextStyle(color: Colors.grey),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        new Padding(padding: EdgeInsets.all(2)),
                        new Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                          color: currCardColor,
                          child: new InkWell(
                            onTap: () {
                              setState(() {
                                screen = !screen;
                              });
                              fb.database().ref("rooms").child(id).child("users").child(currUser.id).child("screen").set(screen);
                            },
                            child: new Container(
                              height: 75,
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  new Icon(screen ? Icons.stop_screen_share : Icons.screen_share, size: 50, color: Colors.grey,),
                                  new Text(screen ? "Stop Sharing" : "Share Screen", style: TextStyle(color: Colors.grey, fontSize: 20),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        new Padding(padding: EdgeInsets.all(2)),
                        new Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                          color: Colors.red,
                          child: new InkWell(
                            onTap: () {
                              game.suspend();
                              router.navigateTo(context, "/home", transition: TransitionType.fadeIn);
                              fb.database().ref("rooms").child(id).child("users").child(currUser.id).remove();
                            },
                            child: new Container(
                              height: 75,
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  new Icon(Icons.exit_to_app, size: 50, color: Colors.white,),
                                  new Text("Leave Room", style: TextStyle(color: Colors.white, fontSize: 20),)
                                ],
                              ),
                            ),
                          ),
                        ),
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
