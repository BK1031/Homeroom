import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:homeroom_flutter/models/chat_message.dart';
import 'package:homeroom_flutter/models/user.dart';
import 'package:homeroom_flutter/utils/config.dart';
import 'package:homeroom_flutter/utils/theme.dart';

class ClassroomChatPage extends StatefulWidget {
  String id;
  ClassroomChatPage(this.id);
  @override
  _ClassroomChatPageState createState() => _ClassroomChatPageState(this.id);
}

class _ClassroomChatPageState extends State<ClassroomChatPage> {

  String id;

  _ClassroomChatPageState(this.id);

  List<Widget> widgetList = new List();
  List<ChatMessage> chatList = new List();
  ChatMessage newMessage = new ChatMessage.plain();
  FocusNode _focusNode = new FocusNode();
  ScrollController _scrollController = new ScrollController();
  TextEditingController _textController = new TextEditingController();

  bool confirmNsfw = false;

  String chatID = "";
  String chatName = "";

  List<String> noNoWordList = new List();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(focusNodeListener);
    fb.database().ref("chatNoNoWords").onChildAdded.listen((event) {
      noNoWordList.add(event.snapshot.val().toString());
    });
    getChat(id);
  }

  Future<Null> focusNodeListener() async {
    if (_focusNode.hasFocus) {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 10.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void getChat(String id) {
    Future.delayed(const Duration(seconds: 1), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 20.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    fb.database().ref("classrooms").child(id).child("chat").onChildAdded.listen((event) {
      ChatMessage message = new ChatMessage.fromSnapshot(event.snapshot);
      fb.database().ref("users").child(message.author.id).once("value").then((value) {
        message.author = new User.fromSnapshot(value.snapshot);
        chatList.add(message);
        setState(() {
          // Add the actual chat message widget
          if (message.mediaType == "text") {
            if (chatList.length > 1 && message.author.id == chatList[chatList.length - 2].author.id &&  message.date.difference(chatList[chatList.length - 2].date).inMinutes.abs() < 5) {
              widgetList.add(new InkWell(
                onLongPress: () {

                },
                child: new Container(
                  padding: EdgeInsets.only(left: 12, right: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Container(width: 52),
                      new Expanded(
                        child: new SelectableText(
                          message.message,
                          style: TextStyle(color: currTextColor, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
            }
            else {
              widgetList.add(new InkWell(
                onLongPress: () {

                },
                child: new Container(
                  padding: EdgeInsets.only(left: 12, top: 8, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Container(
                        child: new ClipRRect(
                          borderRadius: new BorderRadius.all(Radius.circular(45)),
                          child: new CachedNetworkImage(
                            imageUrl: message.author.profilePic,
                            height: 35,
                            width: 35,
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8)),
                      new Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Text(
                              message.author.firstName + " " + message.author.lastName,
                              style: TextStyle(fontSize: 15, color: message.author.role == "Student" ? Colors.grey : mainColor),
                            ),
                            new SelectableText(
                              message.message,
                              style: TextStyle(color: currTextColor, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
            }
          }
          else {
            if (chatList.length > 1 && message.author.id == chatList[chatList.length - 2].author.id &&  message.date.difference(chatList[chatList.length - 2].date).inMinutes.abs() < 5) {
              widgetList.add(new InkWell(
                onLongPress: () {

                },
                child: new Container(
                  padding: EdgeInsets.only(left: 12, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Container(width: 58),
                      new Expanded(
                          child: new ClipRRect(
                            borderRadius: BorderRadius.circular(2.0),
                            child: new CachedNetworkImage(
                              imageUrl: message.message,
                              width: MediaQuery.of(context).size.width > 500 ? 500 : null,
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ));
            }
            else {
              widgetList.add(new InkWell(
                onLongPress: () {

                },
                child: new Container(
                  padding: EdgeInsets.only(left: 12, top: 8, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Container(
                        child: new ClipRRect(
                          borderRadius: new BorderRadius.all(Radius.circular(45)),
                          child: new CachedNetworkImage(
                            imageUrl: message.author.profilePic,
                            height: 35,
                            width: 35,
                          ),
                        ),
                      ),
                      new Padding(padding: EdgeInsets.all(8)),
                      new Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Text(
                              message.author.firstName + " " + message.author.lastName,
                              style: TextStyle(fontSize: 15, color: message.author.role == "Student" ? Colors.grey : mainColor),
                            ),
                            new Padding(padding: EdgeInsets.all(2)),
                            new ClipRRect(
                              borderRadius: BorderRadius.circular(2.0),
                              child: new CachedNetworkImage(
                                imageUrl: message.message,
                                width: MediaQuery.of(context).size.width > 500 ? 500 : null,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
            }
          }
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 20.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    });
  }

  void sendMessage() {
    if (newMessage.message.replaceAll(" ", "").replaceAll("\n", "") != "") {
      // Message is not empty
      if (!checkNSFW(newMessage.message)) {
        fb.database().ref("classrooms").child(id).child("chat").push().set({
          "message": newMessage.message,
          "author": currUser.id,
          "type": "text",
          "date": DateTime.now().toString(),
          "nsfw": false
        });
        _textController.clear();
        newMessage = ChatMessage.plain();
      }
      else {
        // Message kinda not very pc kekw
        setState(() {
          confirmNsfw = true;
        });
      }
    }
  }

  bool checkNSFW(String message) {
    // dart is funny and goes through the entire list before returning something
    bool found = false;
    noNoWordList.forEach((element) {
      if (message.replaceAll(" ", "").replaceAll("\n", "").contains(element)) {
        found = true;
      }
    });
    return found;
  }

  void sendMedia() {
    // showModalBottomSheet(context: context, builder: (BuildContext context) {
    //   return new SafeArea(
    //     child: new Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: <Widget>[
    //         new ListTile(
    //           leading: new Icon(Icons.camera_alt),
    //           title: new Text('Take Photo'),
    //           onTap: takePhoto,
    //         ),
    //         new ListTile(
    //           leading: new Icon(Icons.photo_library),
    //           title: new Text('Photo Library'),
    //           onTap: pickImage,
    //         ),
    //         new ListTile(
    //           leading: new Icon(Icons.clear),
    //           title: new Text('Cancel'),
    //           onTap: () {
    //             router.pop(context);
    //           },
    //         ),
    //       ],
    //     ),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Container(
        child: Column(
          children: [
            new Expanded(
              child: new SingleChildScrollView(
                controller: _scrollController,
                child: new Column(
                    children: widgetList
                ),
              ),
            ),
            new AnimatedContainer(
                padding: EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
                duration: const Duration(milliseconds: 200),
                height: confirmNsfw ? 100 : 0,
                child: new Card(
                  color: Color(0xFFffebba),
                  child: new Container(
                    padding: EdgeInsets.all(8),
                    child: new Row(
                      children: [
                        new Icon(Icons.warning, color: Colors.orangeAccent,),
                        new Padding(padding: EdgeInsets.all(4)),
                        new Text("It looks like your message contains\nsome NSFW content. Are you sure\nyou would like to send this?", style: TextStyle(color: Colors.orangeAccent),),
                        new Padding(padding: EdgeInsets.all(4)),
                        new OutlineButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                          disabledBorderColor: Colors.orangeAccent,
                          highlightedBorderColor: Colors.orangeAccent,
                          color: Colors.orangeAccent,
                          textColor: Colors.orangeAccent,
                          child: new Text("SEND"),
                          onPressed: () {
                            fb.database().ref("classrooms").child(id).child("chat").push().set({
                              "message": newMessage.message,
                              "author": currUser.id,
                              "type": "text",
                              "date": DateTime.now().toString(),
                              "nsfw": true
                            });
                            _textController.clear();
                            newMessage = ChatMessage.plain();
                            setState(() {
                              confirmNsfw = false;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                )
            ),
            new Container(
              padding: EdgeInsets.all(8),
              child: new Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                color: currCardColor,
                child: new ListTile(
                    title: Container(
                      child: Row(
                        children: <Widget>[
                          Material(
                            child: new Container(
                              child: new IconButton(
                                icon: new Icon(Icons.image),
                                color: Colors.grey,
                                onPressed: () {
                                  sendMedia();
                                },
                              ),
                            ),
                            color: currCardColor,
                          ),
                          // Edit text
                          Flexible(
                            child: Container(
                              child: TextField(
                                controller: _textController,
                                focusNode: _focusNode,
                                textInputAction: TextInputAction.newline,
                                textCapitalization: TextCapitalization.sentences,
                                style: TextStyle(color: currTextColor, fontSize: 15.0),
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Type your message...',
                                    hintStyle: TextStyle(color: darkMode ? Colors.grey : Colors.black54)
                                ),
                                onChanged: (input) {
                                  setState(() {
                                    newMessage.message = input;
                                    confirmNsfw = false;
                                  });
                                },
                                onSubmitted: (input) {
                                  sendMessage();
                                },
                              ),
                            ),
                          ),
                          new Material(
                            child: new Container(
                              child: new IconButton(
                                icon: new Icon(
                                  Icons.send,
                                  color: newMessage.message.replaceAll(" ", "").replaceAll("\n", "") != "" ? mainColor : Colors.grey,
                                ),
                                onPressed: () {
                                  sendMessage();
                                },
                              ),
                            ),
                            color: currCardColor,
                          )
                        ],
                      ),
                      width: double.infinity,
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
