import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:homeroom_flutter/utils/config.dart';
import 'package:homeroom_flutter/utils/theme.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
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
                                new Icon(Icons.home, color: mainColor,),
                                new Text("Home", style: TextStyle(color: mainColor),)
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
                                new Icon(Icons.class_, color: Colors.grey),
                                new Text("Classes", style: TextStyle(color: Colors.grey),)
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
              Container(
                width: (MediaQuery.of(context).size.width > 1300) ? 1100 : MediaQuery.of(context).size.width - 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Text(
                      "Welcome back, ${currUser.firstName}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60, color: currTextColor),
                    ),
                    new Padding(padding: EdgeInsets.all(32)),
                    new Row(
                      children: [
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
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    new Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                      color: mainColor,
                                      child: new InkWell(
                                        onTap: () {
                                          router.navigateTo(context, "/room/new", transition: TransitionType.fadeIn);
                                        },
                                        child: new Container(
                                          height: 125,
                                          width: 125,
                                          padding: EdgeInsets.all(8),
                                          child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              new Icon(Icons.video_call, size: 75, color: Colors.white,),
                                              new Text("New Meeting", style: TextStyle(color: Colors.white),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    new Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                      color: mainColor,
                                      child: new InkWell(
                                        onTap: () {
                                          router.navigateTo(context, "/room/new", transition: TransitionType.fadeIn);
                                        },
                                        child: new Container(
                                          height: 125,
                                          width: 125,
                                          padding: EdgeInsets.all(8),
                                          child: new Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              new Icon(Icons.add_box, size: 75, color: Colors.white,),
                                              new Text("Join Meeting", style: TextStyle(color: Colors.white),)
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
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
