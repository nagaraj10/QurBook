import 'package:flutter/material.dart';
import 'package:myfhb/IntroScreens/IntroWidget.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  int currentScreen = 0;
  final screens = [
    IntroWidget(icon_languageIntro),
    IntroWidget(icon_SheelaIntro),
    IntroWidget(icon_qurplanIntro),
    IntroWidget(icon_TrustedAnswerIntro),
    IntroWidget(icon_ReminderIntro),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (value) {
                    setState(() {
                      currentScreen = value;
                    });
                  },
                  itemCount: screens.length,
                  itemBuilder: (context, index) {
                    return screens[currentScreen];
                  })),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                screens.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FlatButton(
              onPressed: () {},
              child: Text(
                'skip',
                style: TextStyle(color: Colors.grey),
              )),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentScreen == index ? HexColor('2831b1') : Colors.grey,
      ),
    );
  }
}
