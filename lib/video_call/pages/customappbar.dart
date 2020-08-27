import 'package:flutter/material.dart';
import 'package:flutter_timer/flutter_timer.dart';

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
            color: Colors.black.withOpacity(0.5),
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
                            (widget.userName.isEmpty || widget.userName != null)
                                ? widget.userName
                                : '',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          //todo this has to be uncomment in future
//                      SizedBox(
//                        width: 10,
//                      ),
//                      Icon(
//                        Icons.mic,
//                        color: Colors.white,
//                        size: 20,
//                      ),
                        ],
                      ),
                      TikTikTimer(
                        backgroundColor: Colors.transparent,
                        initialDate: DateTime.now(),
                        running: _isTimerRun,
                        width: 50,
                        timerTextStyle:
                            TextStyle(color: Colors.white, fontSize: 12),
                        isRaised: false,
                        tracetime: (time) {
                          // print(time.getCurrentSecond);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
