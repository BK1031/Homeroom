import 'package:flutter/material.dart';
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Text(
                "Welcome to Homeroom",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60, color: currTextColor),
              ),
              new RaisedButton(
                elevation: 0,
                padding: EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
                child: new Text("GET STARTED", style: TextStyle(fontSize: 35),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                textColor: Colors.white,
                color: mainColor,
                onPressed: () {

                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
