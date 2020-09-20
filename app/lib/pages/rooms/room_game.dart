import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flame/keyboard.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:homeroom_flutter/models/student.dart';

class ClassroomGame extends BaseGame with KeyboardEvents {
  Size screenSize;
  SpriteComponent component;

  bool goingLeft = false;
  bool goingRight = false;
  bool goingUp = false;
  bool goingDown = false;

  double xposition = 0;
  double yposition = 0;

  Image rightstep1;
  Image rightstep2;
  Image rightstep0;
  Image leftstep1;
  Image leftstep2;
  Image leftstep0;
  Image background;
  Image table;

  List<double> tableLocXs = [100, 100, 400, 400, 700, 700];
  List<double> tableLocYs = [200, 600, 200, 600, 200, 600];

  List<String> studentIDs = List();
  Map<String, Student> students = Map();

  int stepTimer = 0;

  /*
  1: step1
  2: step2
  */
  int stepStage = 1;

  bool moving = false;

  /*
  1: right
  -1: left
   */
  int direction = 1;

  String uid = "";
  String name = "";

  String rID;

  void loadImages() {
    Flame.images.load("rightstep0.png").then((Image value) {
      rightstep0 = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("rightstep1.png").then((Image value) {
      rightstep1 = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("rightstep2.png").then((Image value) {
      rightstep2 = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("leftstep0.png").then((Image value) {
      leftstep0 = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("leftstep1.png").then((Image value) {
      leftstep1 = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("leftstep2.png").then((Image value) {
      leftstep2 = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("background.png").then((Image value) {
      background = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("table.png").then((Image value) {
      table = value;
    },
        onError: (e) {
          print(e.toString());
        });
  }

  ClassroomGame (String roomID) {
    rID = roomID;
    loadImages();

    uid = fb.auth().currentUser.uid;
    name = fb.database().ref("users").child(uid).child("firstName").toString()+" "+fb.database().ref("users").child(uid).child("lastName").toString();
    fb.database().ref("rooms").child(rID).child("users").child(uid).set({
      "x": xposition,
      "y": yposition,
      "stepStage": stepStage,
      "moving": moving,
      "direction": direction
    });

    fb.database().ref("rooms").child(rID).child("users").once("value").then((snapshot) {
      snapshot.snapshot.forEach((childSnapshot) {
        if (childSnapshot.key != uid) {
          studentIDs.add(childSnapshot.key);

          double xval = childSnapshot.val()["x"];
          double yval = childSnapshot.val()["y"];
          int stepVal = childSnapshot.val()["stepStage"];
          bool movVal = childSnapshot.val()["moving"];
          int dirVal = childSnapshot.val()["direction"];
          String namVal = fb.database().ref("users")
              .child(childSnapshot.key)
              .child("firstName")
              .toString() + " " +
              fb.database().ref("users").child(childSnapshot.key).child(
                  "lastName").toString();

          students[childSnapshot.key] =
              Student.fromValues(xval, yval, stepVal, movVal, dirVal, namVal);
        }
      });
    });

    fb.database().ref("rooms").child(rID).child("users").onChildChanged.listen((event) {
      fb.database().ref("rooms").child(rID).child("users").child(event.snapshot.key).onValue.listen((event) {
        if (event.snapshot.key != uid) {
          studentIDs.add(event.snapshot.key);

          double xval = event.snapshot.val()["x"];
          double yval = event.snapshot.val()["y"];
          int stepVal = event.snapshot.val()["stepStage"];
          bool movVal = event.snapshot.val()["moving"];
          int dirVal = event.snapshot.val()["direction"];
          String namVal = fb.database().ref("users")
              .child(event.snapshot.key)
              .child("firstName")
              .toString() + " " +
              fb.database().ref("users").child(event.snapshot.key).child(
                  "lastName").toString();

          students[event.snapshot.key] =
              Student.fromValues(xval, yval, stepVal, movVal, dirVal, namVal);
        }
      });
    });
  }

  void render(Canvas canvas) {
    super.render(canvas);

    //background
    if (background != null) {
      Paint bgPaint = Paint();
      canvas.drawImage(background, new Offset(0, 0), bgPaint);
    }

    //tables
    if (table != null) {
      for (int i = 0; i<tableLocXs.length; i++) {
        Paint tbPaint = Paint();
        canvas.drawImage(table, new Offset(tableLocXs[i], tableLocYs[i]), tbPaint);
      }
    }

    //other students
    if (students.length != null) {
      for (int i = 0; i < studentIDs.length; i++) {
        Paint studentPaint = Paint();

        Student values = students[studentIDs[i]];

        if (values.direction == 1) {
          if (rightstep0 != null && values.moving == false) {
            canvas.drawImage(
                rightstep0, new Offset(values.x, values.y), studentPaint);
          } else if (rightstep1 != null && values.stepStage == 1 &&
              values.moving == true) {
            canvas.drawImage(
                rightstep1, new Offset(values.x, values.y), studentPaint);
          } else if (rightstep2 != null && values.stepStage == 2 &&
              values.moving == true) {
            canvas.drawImage(
                rightstep2, new Offset(values.x, values.y), studentPaint);
          }
        } else {
          if (leftstep0 != null && values.moving == false) {
            canvas.drawImage(
                leftstep0, new Offset(values.x, values.y), studentPaint);
          } else if (leftstep1 != null && values.stepStage == 1 &&
              values.moving == true) {
            canvas.drawImage(
                leftstep1, new Offset(values.x, values.y), studentPaint);
          } else if (leftstep2 != null && values.stepStage == 2 &&
              values.moving == true) {
            canvas.drawImage(
                leftstep2, new Offset(values.x, values.y), studentPaint);
          }
        }
      }
    }

    //user student
    Paint personPaint = Paint();

    if (direction == 1) {
      if (rightstep0 != null && moving == false) {
        canvas.drawImage(rightstep0, new Offset(xposition, yposition), personPaint);
      } else if (rightstep1 != null && stepStage == 1 && moving == true) {
        canvas.drawImage(rightstep1, new Offset(xposition, yposition), personPaint);
      } else if (rightstep2 != null && stepStage == 2 && moving == true) {
        canvas.drawImage(rightstep2, new Offset(xposition, yposition), personPaint);
      }
    } else {
      if (leftstep0 != null && moving == false) {
        canvas.drawImage(leftstep0, new Offset(xposition, yposition), personPaint);
      } else if (leftstep1 != null && stepStage == 1 && moving == true) {
        canvas.drawImage(leftstep1, new Offset(xposition, yposition), personPaint);
      } else if (leftstep2 != null && stepStage == 2 && moving == true) {
        canvas.drawImage(leftstep2, new Offset(xposition, yposition), personPaint);
      }
    }
  }

  bool inTable (double x, double y) {
    for (int i = 0; i < tableLocXs.length; i++) {
      double tableLocX = tableLocXs[i];
      double tableLocY = tableLocYs[i];

      double topLeftX = tableLocX-4;
      double bottomLeftX = tableLocX-100;
      double topRightX = tableLocX+161;
      double bottomRightX = tableLocX+65;

      double topY = tableLocY-80;
      double bottomY = tableLocY+180;

      if (y > topY && y < bottomY) {
        double fractionOfTablePos = (y-topY)/(261);
        double xBoundAtPos;
        if (x < tableLocX) {
          xBoundAtPos = topLeftX - fractionOfTablePos * 96;
          if (x > xBoundAtPos) {
            return true;
          }
        } else {
          xBoundAtPos = topRightX - fractionOfTablePos * 96;
          if (x < xBoundAtPos) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void update(double t) {
    if (moving) {
      stepTimer += 1;
      if (stepTimer >= 10) {
        stepTimer = 0;
        if (stepStage == 1) {
          stepStage = 2;
        } else if (stepStage == 2) {
          stepStage = 1;
        }
      }
    }

    super.update(t);

    if (goingLeft && !goingRight && xposition > 0 && !inTable(xposition - 3, yposition)) {
      xposition -= 3;
      direction = -1;
    }

    if (goingRight && !goingLeft && xposition < 900 && !inTable(xposition + 3, yposition)) {
      xposition += 3;
      direction = 1;
    }

    if (goingUp && !goingDown && yposition > 120 && !inTable(xposition, yposition - 3)) {
      yposition -= 3;
    }

    if (goingDown && !goingUp && yposition < 900 && !inTable(xposition, yposition + 3)) {
      yposition += 3;
    }

    fb.database().ref("rooms").child(rID).child("users").child(uid).set({
      "x": xposition,
      "y": yposition,
      "stepStage": stepStage,
      "moving": moving,
      "direction": direction
    });

    if (!goingLeft && !goingRight && !goingUp && !goingDown) {
      moving = false;
    } else {
      moving = true;
    }
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }

  @override
  void onKeyEvent(e) {
    final bool isKeyDown = e is RawKeyDownEvent;
    if (e.data.keyLabel == "a") {
      if (isKeyDown) {
        goingLeft = true;
      } else {
        goingLeft = false;
      }
    } else if (e.data.keyLabel == "d") {
      if (isKeyDown) {
        goingRight = true;
      } else {
        goingRight = false;
      }
    } else if (e.data.keyLabel == "w") {
      if (isKeyDown) {
        goingUp = true;
      } else {
        goingUp = false;
      }
    } else if (e.data.keyLabel == "s") {
      if (isKeyDown) {
        goingDown = true;
      } else {
        goingDown = false;
      }
    }
  }
}