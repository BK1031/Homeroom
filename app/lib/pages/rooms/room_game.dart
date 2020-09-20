import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

  ui.Image rightstep1;
  ui.Image rightstep2;
  ui.Image rightstep0;
  ui.Image leftstep1;
  ui.Image leftstep2;
  ui.Image leftstep0;
  ui.Image background;
  ui.Image table;
  ui.Image teacherDesk;

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

  /*
  0: teacher desk
  then starts from top left, goes down, then up right, then down...
   */
  int tableID = 0;

  bool suspended = false;

  void loadImages() {
    Flame.images.load("rightstep0.png").then((ui.Image value) {
      rightstep0 = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("rightstep1.png").then((ui.Image value) {
      rightstep1 = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("rightstep2.png").then((ui.Image value) {
      rightstep2 = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("leftstep0.png").then((ui.Image value) {
      leftstep0 = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("leftstep1.png").then((ui.Image value) {
      leftstep1 = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("leftstep2.png").then((ui.Image value) {
      leftstep2 = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("background.png").then((ui.Image value) {
      background = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("table.png").then((ui.Image value) {
      table = value;
    },
        onError: (e) {
          print(e.toString());
        });

    Flame.images.load("teacherDesk.png").then((ui.Image value) {
      teacherDesk = value;
    },
        onError: (e) {
          print(e.toString());
        });
  }

  ClassroomGame (String roomID) {
    rID = roomID;
    loadImages();

    uid = fb.auth().currentUser.uid;
    fb.database().ref("rooms").child(rID).child("users").child(uid).update({
      "x": xposition,
      "y": yposition,
      "stepStage": stepStage,
      "moving": moving,
      "direction": direction,
      "closestTable": tableID
    });

    fb.database().ref("users").child(uid).once("value").then((snapshot) {
      String firstName = snapshot.snapshot.val()["firstName"];
      String lastName = snapshot.snapshot.val()["lastName"];
      name = firstName + " " + lastName;
    });

    fb.database().ref("rooms").child(rID).child("users").once("value").then((snapshot) {
      snapshot.snapshot.forEach((childSnapshot) {
        if (childSnapshot.key != uid) {
          if (!studentIDs.contains(childSnapshot.key)) {
            studentIDs.add(childSnapshot.key);
          }

          double xval = childSnapshot.val()["x"];
          double yval = childSnapshot.val()["y"];
          int stepVal = childSnapshot.val()["stepStage"];
          bool movVal = childSnapshot.val()["moving"];
          int dirVal = childSnapshot.val()["direction"];

          String namVal = "";

          fb.database().ref("users").child(childSnapshot.key).once("value").then((snapshot) {
            String firstName = snapshot.snapshot.val()["firstName"];
            String lastName = snapshot.snapshot.val()["lastName"];
            namVal = firstName + " " + lastName;

            students[childSnapshot.key] =
                Student.fromValues(xval, yval, stepVal, movVal, dirVal, namVal);
          });
        }
      });
    });

    fb.database().ref("rooms").child(rID).child("users").onChildChanged.listen((event) {
      fb.database().ref("rooms").child(rID).child("users").child(event.snapshot.key).onValue.listen((event) {
        if (event.snapshot.key != uid) {
          if (!studentIDs.contains(event.snapshot.key)) {
            studentIDs.add(event.snapshot.key);
          }

          double xval = event.snapshot.val()["x"];
          double yval = event.snapshot.val()["y"];
          int stepVal = event.snapshot.val()["stepStage"];
          bool movVal = event.snapshot.val()["moving"];
          int dirVal = event.snapshot.val()["direction"];
          String namVal = "";
          fb.database().ref("users").child(event.snapshot.key).once("value").then((snapshot) {
            String firstName = snapshot.snapshot.val()["firstName"];
            String lastName = snapshot.snapshot.val()["lastName"];
            namVal = firstName + " " + lastName;
            students[event.snapshot.key].name = namVal;
          });

          students[event.snapshot.key].x = xval;
          students[event.snapshot.key].y = yval;
          students[event.snapshot.key].stepStage = stepVal;
          students[event.snapshot.key].moving = movVal;
          students[event.snapshot.key].direction = dirVal;
        }
      });
    });

    fb.database().ref("rooms").child(rID).child("users").onChildAdded.listen((event) {
      fb.database().ref("rooms").child(rID).child("users").child(event.snapshot.key).onValue.listen((event) {
        if (event.snapshot.key != uid) {
          if (!studentIDs.contains(event.snapshot.key)) {
            studentIDs.add(event.snapshot.key);
          }

          double xval = event.snapshot.val()["x"];
          double yval = event.snapshot.val()["y"];
          int stepVal = event.snapshot.val()["stepStage"];
          bool movVal = event.snapshot.val()["moving"];
          int dirVal = event.snapshot.val()["direction"];
          String namVal = "";
          fb.database().ref("users").child(event.snapshot.key).once("value").then((snapshot) {
            String firstName = snapshot.snapshot.val()["firstName"];
            String lastName = snapshot.snapshot.val()["lastName"];
            namVal = firstName + " " + lastName;

            students[event.snapshot.key] =
                Student.fromValues(xval, yval, stepVal, movVal, dirVal, namVal);
          });
        }
      });
    });

    fb.database().ref("rooms").child(rID).child("users").onChildRemoved.listen((event) {
      fb.database().ref("rooms").child(rID).child("users").child(event.snapshot.key).onValue.listen((event) {
        students.remove(event.snapshot.key);
        studentIDs.remove(event.snapshot.key);
      });
    });
  }

  void render(Canvas canvas) {
    if (!suspended) {
      super.render(canvas);

      //background
      if (background != null) {
        Paint bgPaint = Paint();
        canvas.drawImage(background, new Offset(0, 0), bgPaint);
      }

      if (teacherDesk != null) {
        Paint tdPaint = Paint();
        canvas.drawImage(teacherDesk, new Offset(750, 100), tdPaint);
      }

      //tables
      if (table != null) {
        for (int i = 0; i < tableLocXs.length; i++) {
          Paint tbPaint = Paint();
          canvas.drawImage(
              table, new Offset(tableLocXs[i], tableLocYs[i]), tbPaint);
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

          TextConfig config = TextConfig(
              fontSize: 24, fontFamily: "Product Sans");
          config.render(canvas, values.name, Position(values.x, values.y - 30));
        }
      }

      //user student
      Paint personPaint = Paint();

      if (direction == 1) {
        if (rightstep0 != null && moving == false) {
          canvas.drawImage(
              rightstep0, new Offset(xposition, yposition), personPaint);
        } else if (rightstep1 != null && stepStage == 1 && moving == true) {
          canvas.drawImage(
              rightstep1, new Offset(xposition, yposition), personPaint);
        } else if (rightstep2 != null && stepStage == 2 && moving == true) {
          canvas.drawImage(
              rightstep2, new Offset(xposition, yposition), personPaint);
        }
      } else {
        if (leftstep0 != null && moving == false) {
          canvas.drawImage(
              leftstep0, new Offset(xposition, yposition), personPaint);
        } else if (leftstep1 != null && stepStage == 1 && moving == true) {
          canvas.drawImage(
              leftstep1, new Offset(xposition, yposition), personPaint);
        } else if (leftstep2 != null && stepStage == 2 && moving == true) {
          canvas.drawImage(
              leftstep2, new Offset(xposition, yposition), personPaint);
        }
      }

      TextConfig config = TextConfig(fontSize: 24, fontFamily: "Product Sans");
      config.render(canvas, name, Position(xposition, yposition - 30));

      TextConfig tableConfig = TextConfig(
          fontSize: 48, fontFamily: "Product Sans");
      String tableText = "At Table " + tableID.toString();
      if (tableID == 0) {
        tableText = "At Teacher Desk";
      }
      tableConfig.render(canvas, tableText, Position(10, 10));
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

  bool inTeacherDesk (double x, double y) {
    double midTableX = 750.0+120.0;
    double midTableY = 150.0-90.0;

    double midStudentX = x + 64;
    double midStudentY = y + 64;

    if ((midStudentX-midTableX).abs() < 120 && (midStudentY-midTableY).abs() < 90) {
      return true;
    }

    return false;
  }

  void setClosestTable () {
    double midDeskX = 750.0+120.0;
    double midDeskY = 150.0-90.0;

    double midStudentX = xposition + 64;
    double midStudentY = yposition + 64;
    double shortestDistance = pow((midStudentX - midDeskX), 2) + pow((midStudentY - midDeskY), 2);
    tableID = 0;

    for (int i = 0; i < 6; i++) {
      double midTableX = tableLocXs[i] + 96;
      double midTableY = tableLocYs[i] + 128;

      double toTable = pow((midStudentX - midTableX), 2) + pow((midStudentY - midTableY), 2);
      if (toTable < shortestDistance) {
        shortestDistance = toTable;
        tableID = i+1;
      }
    }
  }



  void update(double t) {
    if (!suspended) {
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

      if (goingLeft && !goingRight && xposition > 0 &&
          !inTeacherDesk(xposition - 3, yposition) &&
          !inTable(xposition - 3, yposition)) {
        xposition -= 3;
        direction = -1;
      }

      if (goingRight && !goingLeft && xposition < 900 &&
          !inTeacherDesk(xposition + 3, yposition) &&
          !inTable(xposition + 3, yposition)) {
        xposition += 3;
        direction = 1;
      }

      if (goingUp && !goingDown && yposition > 120 &&
          !inTeacherDesk(xposition, yposition - 3) &&
          !inTable(xposition, yposition - 3)) {
        yposition -= 3;
      }

      if (goingDown && !goingUp && yposition < 900 &&
          !inTeacherDesk(xposition, yposition + 3) &&
          !inTable(xposition, yposition + 3)) {
        yposition += 3;
      }

      setClosestTable();

      fb.database().ref("rooms").child(rID).child("users").child(uid).update({
        "x": xposition,
        "y": yposition,
        "stepStage": stepStage,
        "moving": moving,
        "direction": direction,
        "closestTable": tableID
      });

      for (int i = 0; i <= 6; i++) {
        if (i != tableID) {
          fb.database().ref("rooms").child(rID).child("tables").child(
              i.toString()).update({
            uid: false
          });
        }
      }

      fb.database().ref("rooms").child(rID).child("tables").child(
          tableID.toString()).update({
        uid: true
      });

      if (!goingLeft && !goingRight && !goingUp && !goingDown) {
        moving = false;
      } else {
        moving = true;
      }
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

  void suspend () {
    suspended = true;
  }
}