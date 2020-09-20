import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:homeroom_flutter/models/classroom.dart';
import 'package:homeroom_flutter/utils/config.dart';
import 'package:homeroom_flutter/utils/theme.dart';
import 'package:intl/intl.dart';

class ClassroomPage extends StatefulWidget {
  @override
  _ClassroomPageState createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {

  List<Classroom> classrooms = new List();

  void createClass() {
    String name = "";
    String teacher = "";
    String section = "";

    var rnd = new Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    String roomCode = next.toInt().toString();

    TextEditingController controller = new TextEditingController();
    controller.text = "${currUser.firstName} ${currUser.lastName}";
    showDialog(
        context: context,
        child: new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          backgroundColor: currCardColor,
          title: new Text("Create Class", style: TextStyle(color: currTextColor),),
          content: Container(
            width: 550,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      new Text("Join Code: $roomCode"),
                      new IconButton(icon: Icon(Icons.help), tooltip: "This is the code students can use to join your classroom",)
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 16),
                  child: new TextField(
                    decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        )
                    ),
                    onChanged: (input) {
                      name = input;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 16),
                  child: new TextField(
                    decoration: InputDecoration(
                        labelText: "Section",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        )
                    ),
                    onChanged: (input) {
                      section = input;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 16),
                  child: new TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        labelText: "Teacher",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        )
                    ),
                    onChanged: (input) {
                      teacher = input;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            new FlatButton(
                child: new Text("CANCEL"),
                textColor: mainColor,
                onPressed: () {
                  router.pop(context);
                }
            ),
            new FlatButton(
                child: new Text("CREATE"),
                textColor: mainColor,
                onPressed: () {
                  if (name != "" && section != "" && teacher != "") {
                    fb.database().ref("classrooms").child(roomCode).set({
                      "name": name,
                      "section": section,
                      "teacher": teacher
                    });
                    fb.database().ref("users").child(currUser.id).child("classrooms").child(roomCode).set(roomCode);
                    router.pop(context);
                  }
                }
            )
          ],
        )
    );
  }

  void joinClass() {
    String joinCode = "";
    showDialog(
        context: context,
        child: new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          backgroundColor: currCardColor,
          title: new Text("Join Class", style: TextStyle(color: currTextColor),),
          content: Container(
            width: 550,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 16),
                  child: new TextField(
                    decoration: InputDecoration(
                        labelText: "Join Code",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        )
                    ),
                    onChanged: (input) {
                      joinCode = input;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            new FlatButton(
                child: new Text("CANCEL"),
                textColor: mainColor,
                onPressed: () {
                  router.pop(context);
                }
            ),
            new FlatButton(
                child: new Text("JOIN"),
                textColor: mainColor,
                onPressed: () {
                  if (joinCode != "") {
                    fb.database().ref("classrooms").child(joinCode).once("value").then((value) {
                      if (value.snapshot.val() != null) {
                        // Code is valid
                        fb.database().ref("users").child(currUser.id).child("classrooms").child(joinCode).set(joinCode);
                        router.pop(context);
                      }
                    });
                  }
                }
            )
          ],
        )
    );
  }

  @override
  void initState() {
    super.initState();
    fb.database().ref("users").child(currUser.id).child("classrooms").onChildAdded.listen((event) {
      fb.database().ref("classrooms").child(event.snapshot.val()).once("value").then((value) {
        setState(() {
          classrooms.add(new Classroom.fromSnapshot(value.snapshot));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        label: new Text(currUser.role == "Student" ? "JOIN CLASS": "NEW CLASS", style: TextStyle(color: Colors.white),),
        icon: Icon(Icons.add, color: Colors.white,),
        elevation: 0,
        onPressed: () {
          currUser.role == "Student" ? joinClass() : createClass();
        },
      ),
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
                    new Text(
                      "My Classes",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: currTextColor),
                    ),
                    new Padding(padding: EdgeInsets.all(32)),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Expanded(
                          child: Container(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: classrooms.map((classroom) => Container(
                                padding: EdgeInsets.only(bottom: 8),
                                child: new Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                  child: new InkWell(
                                    onTap: () {
                                      router.navigateTo(context, "/classroom/${classroom.id}", transition: TransitionType.fadeIn);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          new Text(classroom.section, style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 50),),
                                          new Padding(padding: EdgeInsets.all(8)),
                                          new Expanded(
                                            child: new Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                new Text(classroom.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                                new Text(classroom.teacher, style: TextStyle(fontSize: 18, color: Colors.grey),),
                                              ],
                                            ),
                                          ),
                                          new Icon(Icons.arrow_forward_ios, color: mainColor,)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )).toList()
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
                                    padding: EdgeInsets.all(16),
                                    child: new Column(
                                      children: [
                                        new ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                          child: new CachedNetworkImage(
                                            imageUrl: currUser.profilePic,
                                            height: 100,
                                          ),
                                        ),
                                        new Padding(padding: EdgeInsets.all(8)),
                                        new Text(
                                          currUser.firstName + " " + currUser.lastName,
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        new Padding(padding: EdgeInsets.all(8)),
                                        new ListTile(
                                          leading: new Icon(Icons.mail),
                                          title: new Text(currUser.email),
                                        ),
                                        new ListTile(
                                          leading: new Icon(Icons.grade),
                                          title: new Text(currUser.role),
                                        ),
                                      ],
                                    ),
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
