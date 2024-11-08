import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';

import '../../main.dart';

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    /*  // set the paint color to be white
    paint.color = Colors.white;

    // Create a rectangle with size and width same as the canvas
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // draw the rectangle using the paint
    canvas.drawRect(rect, paint); */

    /* paint.color = Colors.yellow;

    // create a path
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    // close the path to form a bounded shape
    path.close();

    canvas.drawPath(path, paint); */

    // set the color property of the paint
    paint.color = Colors.deepOrange;

    final Gradient gradient = LinearGradient(colors: <Color>[
      //Colors.deepPurple[600],
      mAppThemeProvider.primaryColor,
      mAppThemeProvider.gradientColor,
    ], stops: [
      0.5,
      1.0
    ]);

    var rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final Paint paint1 = Paint()..shader = gradient.createShader(rect);

    // center of the canvas is (x,y) => (width/2, height/2)
    var bottomRight = Offset(size.width / 2, size.height + 60);

    // draw the circle with center having radius 75.0
    canvas.drawCircle(bottomRight, 260, paint1);

    // set the color property of the paint
    paint.color = Colors.white;

    // center of the canvas is (x,y) => (width/2, height/2)
    var innerCircle = Offset(size.width / 2, size.height + 50);

    // draw the circle with center having radius 75.0
    canvas.drawCircle(innerCircle, 150.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
