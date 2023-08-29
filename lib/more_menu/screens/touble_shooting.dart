import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TroubleShooting extends StatefulWidget {
  TroubleShooting();

  @override
  _TroubleShootingState createState() => _TroubleShootingState();
}

class _TroubleShootingState extends State<TroubleShooting> {
  bool isFirstym = true;
  late Timer _timer;
  late Random _random;
  String _annotationValue = '50 %';
  double _pointerValue = 50;
  bool startTest = true;

  @override
  void initState() {
    _random = Random();
    _timer = Timer.periodic(const Duration(milliseconds: 1200), (_timer) {
      setState(() {
        int _value = _random.nextInt(100);
        if (_value > 4 && _value < 100) {
          _pointerValue = _value.toDouble();
          _annotationValue = _value.toString() + ' %';
          if (_pointerValue >= 80) {
            startTest = true;
          }
        }
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: 24.0.sp,
            onTap: () {
              Navigator.pop(context, false);
            },
          ),
          actions: <Widget>[]),
      body: startTest
          ? Center(
              child: GestureDetector(
              onTap: () {
                setState(() {
                  startTest = false;
                });
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(CommonUtil().getMyPrimaryColor()),
                ),
                child: Center(
                  child: Text('Start',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0.sp,
                        color: ColorUtils.white,
                      )),
                ),
              ),
            ))
          : Container(
              child: ListView(children: <Widget>[
              /*SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: false,
                showTicks: false,
                startAngle: 270,
                endAngle: 270,
                minimum: 0,
                maximum: 100,
                radiusFactor: 0.85,
                axisLineStyle: AxisLineStyle(
                    color: Color.fromRGBO(106, 110, 246, 0.2),
                    thicknessUnit: GaugeSizeUnit.factor,
                    thickness: 0.1),
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      angle: 0,
                      positionFactor: 1.2,
                      widget: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            child: Text(
                              _annotationValue,
                              style: TextStyle(
                                  fontFamily: 'Times',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      )),
                ],
                pointers: <GaugePointer>[
                  RangePointer(
                      value: _pointerValue,
                      cornerStyle: CornerStyle.bothCurve,
                      enableAnimation: true,
                      animationDuration: 1200,
                      animationType: AnimationType.ease,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: Color(CommonUtil().getMyPrimaryColor()),
                      width: 0.1),
                ]),
          ],
        ),
        CircularStepProgressIndicator(
          totalSteps: 20,
          currentStep: 0,
          stepSize: 20,
          selectedColor: Colors.red,
          unselectedColor: Colors.grey,
          padding: pi / 20,
          width: 150,
          height: 150,
          startingAngle: -pi * 2,
          arcSize: pi * 2,
          gradientColor: LinearGradient(
            colors: [Colors.red, Colors.grey],
          ),
        ),
        SizedBox(
          height: 200.0,
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: new CircularProgressIndicator(
                      strokeWidth: 15.0,
                      value: _pointerValue / 100,
                      color: Color(
                          CommonUtil().getMyPrimaryColor()), //<-- SEE HERE
                      backgroundColor: Colors.grey[100]),
                ),
              ),
              Center(child: Text(_annotationValue)),
            ],
          ),
        ),
       */
              SizedBox(
                height: 100,
              ),
              SizedBox(
                height: 200.0,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.0, end: 1),
                            duration: const Duration(milliseconds: 3500),
                            builder: (context, value, _) =>
                                new CircularProgressIndicator(
                                    strokeWidth: 15.0,
                                    value: _pointerValue / 100,
                                    color: Color(CommonUtil()
                                        .getMyPrimaryColor()), //<-- SEE HERE
                                    backgroundColor: Colors.grey[100])),
                      ),
                    ),
                    Center(child: Text(_annotationValue)),
                  ],
                ),
              ),
            ])),
    );
  }
}
