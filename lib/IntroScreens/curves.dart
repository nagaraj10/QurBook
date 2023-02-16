import 'package:flutter/material.dart';
import '../constants/variable_constant.dart';
import '../src/utils/colors_utils.dart';

class TopCommonCureveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height / 3,
      width: width,
      child: Stack(
        children: [
          CurveForIntro(110, width, false),
          CurveForIntro(100, width, true),
          Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                icon_qurplan,
                height: width / 3,
                width: width / 3,
              ))
        ],
      ),
    );
  }
}

class CurveForIntro extends StatelessWidget {
  double heightForTheCurve;
  double widthForTheCurve;
  bool istopSemiCurve;

  CurveForIntro(
      this.heightForTheCurve, this.widthForTheCurve, this.istopSemiCurve);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthForTheCurve,
      height: heightForTheCurve,
      child: CustomPaint(
        painter: SemiCurveWithRectPainter(
            istopSemiCurve ? HexColor('dce1f4') : HexColor('e9ecf8')),
      ),
    );
  }
}

class SemiCurveWithRectPainter extends CustomPainter {
  Color fillingColor;
  SemiCurveWithRectPainter(this.fillingColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = fillingColor
      ..style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height * 2, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
