import 'package:fluro/fluro.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';
import 'package:homeroom_flutter/models/user.dart';
import 'package:homeroom_flutter/utils/config.dart';
import 'package:homeroom_flutter/utils/theme.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;

  String email = "";
  String password = "";

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
      fb.auth().signInWithEmailAndPassword(email, password).then((value) async {
        fb.database().ref("users").child(fb.auth().currentUser.uid).once("value").then((value) {
          currUser = new User.fromSnapshot(value.snapshot);
          print("––––––––––––– DEBUG INFO ––––––––––––––––");
          print("NAME: ${currUser.firstName} ${currUser.lastName}");
          print("EMAIL: ${currUser.email}");
          print("ROLE: ${currUser.role}");
          print("–––––––––––––––––––––––––––––––––––––––––");
          if (value.snapshot.val()["darkMode"] != null && value.snapshot.val()["darkMode"]) {
            setState(() {
              darkMode = true;
              currBackgroundColor = darkBackgroundColor;
              currCardColor = darkCardColor;
              currDividerColor = darkDividerColor;
              currTextColor = darkTextColor;
            });
          }
          Future.delayed(const Duration(milliseconds: 800), () {
            router.navigateTo(context, "/home", transition: TransitionType.fadeIn, replace: true);
          });
        });
      });
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
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                            ),
                            new Padding(padding: EdgeInsets.all(12)),
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
                            new Visibility(
                              visible: !loading,
                              child: Container(
                                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                  width: double.maxFinite,
                                  child: new RaisedButton(
                                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                                    elevation: 0,
                                    child: new Text("LOGIN", style: TextStyle(fontSize: 20),),
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
