import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderState createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSliderPage> {
  List<Slide> pages = new List<Slide>();

  @override
  void initState() {
    super.initState();

    pages.add(slideContent(
        Constants.INTRO_SLIDE_TITLE_1, Constants.INTRO_SLIDE_DESC_1, 1));
    pages.add(slideContent(
        Constants.INTRO_SLIDE_TITLE_2, Constants.INTRO_SLIDE_DESC_2, 2));
    pages.add(slideContent(
        Constants.INTRO_SLIDE_TITLE_3, Constants.INTRO_SLIDE_DESC_3, 3));
    pages.add(slideContent(
        Constants.INTRO_SLIDE_TITLE_4, Constants.INTRO_SLIDE_DESC_4, 4));
    pages.add(slideContent(
        Constants.INTRO_SLIDE_TITLE_5, Constants.INTRO_SLIDE_DESC_5, 5));
  }

  void onDonePress() {
    //PageNavigator.goToPermanent(context,router.rt_Signinscreen);
    PageNavigator.goToPermanent(context, router.rt_WebCognito);
  }

  Widget renderNextBtn() {
    return Text(
      variable.strNext,
      style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()), fontSize: 18.0.sp),
    );
  }

  Widget renderDoneBtn() {
    return Text(
      variable.strDONE,
      style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()), fontSize: 18.0.sp),
    );
  }

  Widget renderSkipBtn() {
    return Text(
      variable.strSKIP,
      style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()), fontSize: 18.0.sp),
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

  slideContent(String titleString, String descString, int index) {
    return Slide(
      title: titleString,
      styleTitle: TextStyle(
        color: Colors.black,
        fontSize: 24.0.sp,
      ),
      description: descString,
      styleDescription: TextStyle(
        color: Colors.black,
        fontSize: 16.0.sp,
      ),
      pathImage: variable.slideIcons[index - 1],
      heightImage: 150.0.h,
      widthImage: 150.0.h,
      foregroundImageFit: BoxFit.scaleDown,
      colorBegin: Colors.white,
      colorEnd: Colors.white,
      directionColorBegin: Alignment.topRight,
      directionColorEnd: Alignment.bottomLeft,
    );
  }
}
