import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:homeroom_flutter/utils/config.dart';
import 'package:homeroom_flutter/utils/theme.dart';

class ClassroomPage extends StatefulWidget {
  @override
  _ClassroomPageState createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
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
              new Padding(padding: EdgeInsets.all(32)),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Text(
                      "Welcome to Homeroom",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60, color: currTextColor),
                    ),
                    new Padding(padding: EdgeInsets.all(32)),
                    new RaisedButton(
                      elevation: 0,
                      padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
                      child: new Text("GET STARTED", style: TextStyle(fontSize: 35),),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      textColor: Colors.white,
                      color: mainColor,
                      onPressed: () {
                        router.navigateTo(context, "/register", transition: TransitionType.fadeIn);
                      },
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
