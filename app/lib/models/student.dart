class Student {
  double x;
  double y;
  int stepStage = 1;
  bool moving = false;
  int direction = 1;
  String name = "";

  Student() {
    x = 0;
    y = 0;
  }

  Student.fromValues(double xPos, double yPos, int ss, bool mov, int dir, String nam) {
    x = xPos;
    y = yPos;
    stepStage = ss;
    bool moving = mov;
    int direction = dir;
    String name = nam;
  }
}