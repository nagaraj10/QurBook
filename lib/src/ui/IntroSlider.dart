import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderState createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSliderPage> {
  List<Slide> pages = new List<Slide>();

  @override
  void initState() {
    super.initState();

    pages.add(
      new Slide(
        title: "Click ''n'' Store",
        styleTitle: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
        ),
        description:
            "A secure place to store all your family\n health records digitally. Easier to retrieve,\n your mediacal records are avaiable anytime,\n anywhere!",
        styleDescription: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        pathImage: "assets/slide_icons/slide_paper.png",
        heightImage: 150,
        widthImage: 150,
        foregroundImageFit: BoxFit.scaleDown,
        colorBegin: Colors.white,
        colorEnd: Colors.white,
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );

    pages.add(
      new Slide(
        title: "Sharing is Caring",
        styleTitle: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
        ),
        description:
            "You can share and receive personal health\n records between hospitals, clinics and labs.\n No more carring big files with all your\n health record printouts!",
        styleDescription: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        pathImage: "assets/slide_icons/slide_share.png",
        heightImage: 150,
        widthImage: 150,
        foregroundImageFit: BoxFit.scaleDown,
        colorBegin: Colors.white,
        colorEnd: Colors.white,
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );

    pages.add(
      new Slide(
        title: "Click'n'go",
        styleTitle: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
        ),
        description:
            "Just click a photo of your medical device\n readings. we will digitize the values using our\n SMART AI",
        styleDescription: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        pathImage: "assets/slide_icons/slide_touch.png",
        heightImage: 150,
        widthImage: 150,
        foregroundImageFit: BoxFit.scaleDown,
        colorBegin: Colors.white,
        colorEnd: Colors.white,
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );

    pages.add(
      new Slide(
        title: "Meet AI Maya",
        styleTitle: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
        ),
        description:
            "Just say \"Talk to Super Maya\" and start\n your voice chat with the world\'s 1st\n conversational AI health assistant to get \nvital insights of your health. you don\'t want to miss this!",
        styleDescription: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        pathImage: "assets/slide_icons/slide_maya.png",
        heightImage: 150,
        widthImage: 150,
        foregroundImageFit: BoxFit.scaleDown,
        colorBegin: Colors.white,
        colorEnd: Colors.white,
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );

    pages.add(
      new Slide(
        title: "Sync",
        styleTitle: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
        ),
        description:
            "Google Fit ready !!. Synchronize all your\n Google device data and track your activities",
        styleDescription: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        pathImage: "assets/slide_icons/slide_sync.png",
        heightImage: 150,
        widthImage: 150,
        foregroundImageFit: BoxFit.scaleDown,
        colorBegin: Colors.white,
        colorEnd: Colors.white,
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );

    pages.add(
      new Slide(
        title: "Good Health. \nHappy Family !!",
        maxLineTitle: 2,
        styleTitle: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
        ),
        description: "You are good to go. Let\'s get started",
        styleDescription: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        pathImage: "assets/slide_icons/slide_fhb.png",
        heightImage: 150,
        widthImage: 150,
        foregroundImageFit: BoxFit.scaleDown,
        colorBegin: Colors.white,
        colorEnd: Colors.white,
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
  }

  void onDonePress() {
    PageNavigator.goToPermanent(context, '/sign_in_screen');
  }

  Widget renderNextBtn() {
    return Text(
      'NEXT',
      style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()), fontSize: 18),
    );
  }

  Widget renderDoneBtn() {
    return Text(
      'DONE',
      style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()), fontSize: 18),
    );
  }

  Widget renderSkipBtn() {
    return Text(
      'SKIP',
      style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()), fontSize: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.pages,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Colors.transparent,
      highlightColorSkipBtn: Color(CommonUtil().getMyPrimaryColor()),

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: onDonePress,
      colorDoneBtn: Colors.transparent,
      highlightColorDoneBtn: Color(CommonUtil().getMyPrimaryColor()),

      // Dot indicator
      colorDot: Color(CommonUtil().getMyPrimaryColor()).withOpacity(0.5),
      colorActiveDot: Color(CommonUtil().getMyPrimaryColor()),
      sizeDot: 11.0,

      // Show or hide status bar
      shouldHideStatusBar: false,
      backgroundColorAllSlides: Colors.transparent,
    );
  }
}
