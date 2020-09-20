import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:homeroom_flutter/utils/config.dart';
import 'package:homeroom_flutter/utils/theme.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

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
