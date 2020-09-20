import 'package:easy_web_view/easy_web_view.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:homeroom_flutter/utils/config.dart';
import 'package:homeroom_flutter/utils/theme.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  static ValueKey key = ValueKey('key_0');
  String src = "https://www.youtube.com/embed/ptBeQJm_xps";

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
                        new FlatButton(
                          child: new Text("LOGIN"),
                          onPressed: () {
                            router.navigateTo(context, "/login", transition: TransitionType.fadeIn);
                          },
                        ),
                        new FlatButton(
                          child: new Text("REGISTER"),
                          onPressed: () {
                            router.navigateTo(context, "/register", transition: TransitionType.fadeIn);
                          },
                        )
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
                    new Padding(padding: EdgeInsets.all(20)),
                    new ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: new Container(
                        width: (MediaQuery.of(context).size.width > 1300) ? 1100 : MediaQuery.of(context).size.width - 50,
                        height: 550,
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
                    new Padding(padding: EdgeInsets.all(32)),
                    Container(
                      width: (MediaQuery.of(context).size.width > 1300) ? 1100 : MediaQuery.of(context).size.width - 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text("We have noticed a larger lack of attention and interaction in online classes than in in-person classes.", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 40),),
                          new Padding(padding: EdgeInsets.all(8)),
                          new Text("This is why we created Homeroom, a more fun, interactive meeting software for education that caters to all grade levels. As part of HomeRoom, you can move an avatar around a virtual classroom, meeting other students. The audio projected to others scales based on your distance from them in the classroom, allowing you to have better peer-to-peer interactions.", style: TextStyle(color: currTextColor, fontWeight: FontWeight.normal, fontSize: 20),),
                          new Padding(padding: EdgeInsets.all(16)),
                          new Text("Break out into different table group discussions", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 40),),
                          new Padding(padding: EdgeInsets.all(8)),
                          new Text("Homeroom allows you to break out into different table group discussions and ask your teacher for one-on-one help by walking to their desk. You can also get daily assignments by walking to the file cabinet. Homeroom is the perfect solution to create an interactive and focused classroom environment for students to learn in the best way possible.", style: TextStyle(color: currTextColor, fontWeight: FontWeight.normal, fontSize: 20),),
                        ],
                      ),
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
                    ),
                    new Padding(padding: EdgeInsets.all(32)),
                    new Text(appVersion.toString())
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
