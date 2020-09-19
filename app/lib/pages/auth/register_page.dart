import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:homeroom_flutter/models/user.dart';
import 'package:homeroom_flutter/utils/config.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:homeroom_flutter/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool loading = false;

  String firstName = "";
  String lastName = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  String role = "Student";

  void alert(String alert) {
    showDialog(
        context: context,
        child: new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          backgroundColor: currCardColor,
          title: new Text("Alert", style: TextStyle(color: currTextColor),),
          content: new Text(alert, style: TextStyle(color: currTextColor)),
          actions: [
            new FlatButton(
                child: new Text("GOT IT"),
                textColor: mainColor,
                onPressed: () {
                  router.pop(context);
                }
            )
          ],
        )
    );
  }

  Future<void> register() async {
    setState(() {
      loading = true;
    });
    try {
      if (firstName == "" || lastName == "" || email == "") {
        alert("Some fields are empty!");
      }
      else if (password != confirmPassword) {
        alert("Passwords do not match!");
      }
      else {
        await fb.auth().createUserWithEmailAndPassword(email, password).then((value) async {
          print(value.user.uid);
          await fb.database().ref("users").child(value.user.uid).set({
            "firstName": firstName.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
            "lastName": lastName.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
            "email": email,
            "role": role,
            "profile": currUser.profilePic
          });
          currUser.id = value.user.uid;
          currUser.firstName = firstName;
          currUser.lastName = lastName;
          currUser.role = role;
          router.navigateTo(context, "/home?new", transition: TransitionType.fadeIn, clearStack: true);
        });
      }
    } catch(err) {
      print(err);
      alert("An error occured while creating your account: ${err.toString()}");
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currBackgroundColor,
      body: Center(
        child: new Container(
          width: 700,
          height: 550,
          child: new Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            child: new Container(
              child: Row(
                children: [
                  new Expanded(
                    flex: 4,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: mainColor,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Image.asset(
                            "images/homeroom-square.png",
                            color: Colors.white,
                            height: 75,
                          )
                        ],
                      ),
                    ),
                  ),
                  new Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      color: currCardColor,
                      child: new SingleChildScrollView(
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            new Text(
                              "Create Account",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                            ),
                            new Padding(padding: EdgeInsets.all(12)),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  new Expanded(
                                    child: new TextField(
                                      decoration: InputDecoration(
                                        hintText: "First Name",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(12))
                                        )
                                      ),
                                      onChanged: (input) {
                                        firstName = input;
                                      },
                                    ),
                                  ),
                                  new Padding(padding: EdgeInsets.all(8)),
                                  new Expanded(
                                    child: new TextField(
                                      decoration: InputDecoration(
                                          hintText: "Last Name",
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(12))
                                          )
                                      ),
                                      onChanged: (input) {
                                        lastName = input;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                              child: new TextField(
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12))
                                    )
                                ),
                                onChanged: (input) {
                                  email = input;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                              child: new TextField(
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12))
                                    )
                                ),
                                obscureText: true,
                                onChanged: (input) {
                                  password = input;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                              child: new TextField(
                                decoration: InputDecoration(
                                    hintText: "Confirm Password",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12))
                                    )
                                ),
                                obscureText: true,
                                onChanged: (input) {
                                  confirmPassword = input;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                              child: new Column(
                                children: [
                                  new Text("I am a..."),
                                  new Row(
                                    children: [
                                      new Expanded(
                                        child: new RadioListTile(
                                          groupValue: "Student",
                                          title: new Text("Student"),
                                          value: role,
                                          onChanged: (value) {
                                            setState(() {
                                              role = "Student";
                                            });
                                          },
                                        )
                                      ),
                                      new Expanded(
                                          child: new RadioListTile(
                                            groupValue: "Teacher",
                                            title: new Text("Teacher"),
                                            value: role,
                                            onChanged: (value) {
                                              setState(() {
                                                role = "Teacher";
                                              });
                                            },
                                          )
                                      )
                                    ],
                                  )
                                ],
                              )
                            ),
                            new Visibility(
                              visible: !loading,
                              child: Container(
                                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                width: double.maxFinite,
                                child: new RaisedButton(
                                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                                  elevation: 0,
                                  child: new Text("CREATE ACCOUNT", style: TextStyle(fontSize: 20),),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                  textColor: Colors.white,
                                  color: mainColor,
                                  onPressed: () {
                                    register();
                                  },
                                )
                              ),
                            ),
                            new Visibility(
                              visible: loading,
                              child: Container(
                                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                  child: HeartbeatProgressIndicator(
                                    child: new Image.asset(
                                      "images/homeroom-owl.png",
                                      height: 35,
                                    ),
                                  )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
