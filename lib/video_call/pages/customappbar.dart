import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/video_call/widgets/custom_timer.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

import '../../main.dart';

class CustomAppBar extends StatefulWidget {
  final String userName;
  const CustomAppBar(this.userName);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isTimerRun = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _isTimerRun = false;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Container(
            color: mAppThemeProvider.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            (widget.userName != null)
                                ? widget.userName
                                : '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0.sp,
                            ),
                          ),
                          //todo this has to be uncomment in future
                        ],
                      ),
                      CustomTimer(
                        backgroundColor: Colors.transparent,
                        initialDate: DateTime.now(),
                        running: _isTimerRun,
                        width: 50.0.w,
                        timerTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0.sp,
                        ),
                        isRaised: false,
                        tracetime: (time) {},
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );

    /* return Consumer<AudioCallProvider>(builder: (context, status, child) {
+      return status?.isAudioCall
+          ? Wrap(
+              children: [
+                Container(
+                  alignment: Alignment.center,
+                  padding: const EdgeInsets.symmetric(vertical: 40),
+                  child: Container(
+                    //color: Colors.black.withOpacity(0.5),
+                    child: Row(
+                      mainAxisAlignment: MainAxisAlignment.center,
+                      crossAxisAlignment: CrossAxisAlignment.center,
+                      children: <Widget>[
+                        Container(
+                          margin: EdgeInsets.only(left: 10),
+                          child: Column(
+                            mainAxisSize: MainAxisSize.min,
+                            crossAxisAlignment: CrossAxisAlignment.center,
+                            mainAxisAlignment: MainAxisAlignment.center,
+                            children: [
+                              Row(
+                                children: [
+                                  Text(
+                                    (widget.userName.isEmpty ||
+                                            widget.userName != null)
+                                        ? widget.userName
+                                        : '',
+                                    style: TextStyle(
+                                      color: Colors.white,
+                                      fontSize: 20.0.sp,
+                                    ),
+                                  ),
+                                  //todo this has to be uncomment in future
+                                ],
+                              ),
+                              CustomTimer(
+                                backgroundColor: Colors.transparent,
+                                initialDate: DateTime.now(),
+                                running: _isTimerRun,
+                                width: 50.0.w,
+                                timerTextStyle: TextStyle(
+                                  color: Colors.white,
+                                  fontSize: 14.0.sp,
+                                ),
+                                isRaised: false,
+                                tracetime: (time) {},
+                              ),
+                            ],
+                          ),
+                        ),
+                      ],
+                    ),
+                  ),
+                )
+              ],
+            )
+          : Wrap(
+              children: [
+                Container(
+                  alignment: Alignment.topLeft,
+                  padding: const EdgeInsets.symmetric(vertical: 40),
+                  child: Container(
+                    color: Colors.black.withOpacity(0.5),
+                    child: Row(
+                      mainAxisAlignment: MainAxisAlignment.start,
+                      crossAxisAlignment: CrossAxisAlignment.center,
+                      children: <Widget>[
+                        Container(
+                          margin: EdgeInsets.only(left: 10),
+                          child: Column(
+                            mainAxisSize: MainAxisSize.min,
+                            crossAxisAlignment: CrossAxisAlignment.start,
+                            children: [
+                              Row(
+                                children: [
+                                  Text(
+                                    (widget.userName.isEmpty ||
+                                            widget.userName != null)
+                                        ? widget.userName
+                                        : '',
+                                    style: TextStyle(
+                                      color: Colors.white,
+                                      fontSize: 20.0.sp,
+                                    ),
+                                  ),
+                                  //todo this has to be uncomment in future
+                                ],
+                              ),
+                              CustomTimer(
+                                backgroundColor: Colors.transparent,
+                                initialDate: DateTime.now(),
+                                running: _isTimerRun,
+                                width: 50.0.w,
+                                timerTextStyle: TextStyle(
+                                  color: Colors.white,
+                                  fontSize: 14.0.sp,
+                                ),
+                                isRaised: false,
+                                tracetime: (time) {},
+                              ),
+                            ],
+                          ),
+                        ),
+                      ],
+                    ),
+                  ),
+                )
+              ],
+            );
+    }); */
  }
}
