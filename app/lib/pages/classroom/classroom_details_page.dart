import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:homeroom_flutter/models/classroom.dart';
import 'package:homeroom_flutter/models/user.dart';
import 'package:homeroom_flutter/pages/classroom/classroom_chat_page.dart';
import 'package:homeroom_flutter/utils/config.dart';
import 'package:homeroom_flutter/utils/theme.dart';
import 'package:intl/intl.dart';

class ClassroomDetailsPage extends StatefulWidget {
  String id;
  ClassroomDetailsPage(this.id);
  @override
  _ClassroomDetailsPageState createState() => _ClassroomDetailsPageState(this.id);
}

class _ClassroomDetailsPageState extends State<ClassroomDetailsPage> {
  String id;
  Classroom classroom = new Classroom();

  List<User> teachers = new List();
  List<User> users = new List();

  _ClassroomDetailsPageState(this.id);

  @override
  void initState() {
    super.initState();
    fb.database().ref("classrooms").child(id).once("value").then((value) {
      setState(() {
        classroom = new Classroom.fromSnapshot(value.snapshot);
      });
    });
    fb.database().ref("users").onChildAdded.listen((event) {
      User user = new User.fromSnapshot(event.snapshot);
      if (event.snapshot.val()["classrooms"].toString().contains(id)) {
        // user is in class
        setState(() {
          if (user.role == "Student") users.add(user);
          else teachers.add(user);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currBackgroundColor,
      body: new Container(
        child: new SingleChildScrollView(
          child: Column(
            children: [
              new Container(
                padding: EdgeInsets.only(left: 32, top: 8, bottom: 8, right: 32),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Container(
                      child: new Image.asset("images/homeroom-logo.png"),
                    ),
                    new Row(
                      children: [
                        new InkWell(
                          onTap: () {
                            router.navigateTo(context, "/home", transition: TransitionType.fadeIn);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: new Column(
                              children: [
                                new Icon(Icons.home, color: Colors.grey,),
                                new Text("Home", style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                          ),
                        ),
                        new InkWell(
                          onTap: () {
                            router.navigateTo(context, "/classroom", transition: TransitionType.fadeIn);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: new Column(
                              children: [
                                new Icon(Icons.class_, color: mainColor),
                                new Text("Classes", style: TextStyle(color: mainColor),)
                              ],
                            ),
                          ),
                        ),
                        new InkWell(
                          onTap: () {
                            router.navigateTo(context, "/settings", transition: TransitionType.fadeIn);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: new Column(
                              children: [
                                new Icon(Icons.settings, color: Colors.grey),
                                new Text("Settings", style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              new Padding(padding: EdgeInsets.all(16)),
              Container(
                width: (MediaQuery.of(context).size.width > 1300) ? 1100 : MediaQuery.of(context).size.width - 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text(
                          classroom.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: currTextColor),
                        ),
                        new FlatButton(
                          child: new Text("ENTER ROOM"),
                          textColor: mainColor,
                          onPressed: () {
                            fb.database().ref("rooms").child(id).child("hi").set("hi");
                            router.pop(context);
                            router.navigateTo(context, "/room/$id", transition: TransitionType.fadeIn);
                          },
                        )
                      ],
                    ),
                    new Padding(padding: EdgeInsets.all(24)),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Column(
                                    children: teachers.map((user) => Container(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: new Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              new ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                                child: new CachedNetworkImage(
                                                  imageUrl: user.profilePic,
                                                  height: 50,
                                                ),
                                              ),
                                              new Padding(padding: EdgeInsets.all(8)),
                                              new Expanded(
                                                child: new Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    new Text(user.firstName + " " + user.lastName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: mainColor),),
                                                    new Text(user.email, style: TextStyle(fontSize: 18, color: Colors.grey),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )).toList()
                                ),
                                new Column(
                                    children: users.map((user) => Container(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: new Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              new ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                                child: new CachedNetworkImage(
                                                  imageUrl: user.profilePic,
                                                  height: 50,
                                                ),
                                              ),
                                              new Padding(padding: EdgeInsets.all(8)),
                                              new Expanded(
                                                child: new Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    new Text(user.firstName + " " + user.lastName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                                    new Text(user.email, style: TextStyle(fontSize: 18, color: Colors.grey),),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )).toList()
                                ),
                              ],
                            ),
                          ),
                        ),
                        new Padding(padding: EdgeInsets.all(8),),
                        new Expanded(
                          child: Container(
                            child: new Column(
                              children: [
                                new Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                  color: mainColor,
                                  child: new Container(
                                    height: 125,
                                    width: double.maxFinite,
                                    padding: EdgeInsets.all(8),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        new Text(DateFormat().add_jm().format(DateTime.now()), style: TextStyle(color: Colors.white, fontSize: 35),),
                                        new Text(DateFormat().add_yMMMd().format(DateTime.now()), style: TextStyle(color: Colors.white, fontSize: 25),)
                                      ],
                                    ),
                                  ),
                                ),
                                new Padding(padding: EdgeInsets.all(8)),
                                new Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                  color: currCardColor,
                                  child: Container(
                                    height: 400,
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        new Text("Classroom Chat", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                        new Padding(padding: EdgeInsets.all(2)),
                                        new Expanded(child: new ClassroomChatPage(id)),
                                      ],
                                    )
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
