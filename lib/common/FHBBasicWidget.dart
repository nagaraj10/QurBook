import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/ui/audio/AudioRecorder.dart';
import 'package:gmiwidgetspackage/widgets/FlatButton.dart';
import '../main.dart';
import 'errors_widget.dart';
import '../my_providers/models/Doctors.dart';
import '../src/model/user/MyProfileModel.dart';
import '../src/utils/alert.dart';
import '../src/utils/screenutils/size_extensions.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'AudioWidget.dart';
import 'PreferenceUtil.dart';
import '../database/model/UnitsMesurement.dart';
import '../src/model/user/ProfilePicThumbnail.dart';
import '../src/ui/audio/AudioScreenArguments.dart';
import '../src/utils/colors_utils.dart';
import '../widgets/RaisedGradientButton.dart';
import 'CommonUtil.dart';
import 'package:showcaseview/showcaseview.dart';
import '../colors/fhb_colors.dart' as fhbColors;
import '../constants/variable_constant.dart' as variable;
import '../constants/fhb_constants.dart' as Constants;

import 'CommonConstants.dart';
import 'dart:math' as math;
import 'package:myfhb/styles/styles.dart' as fhbStyles;

class FHBBasicWidget {
  FHBBasicWidget();

  DateTime dateTime = DateTime.now();
  String? authToken;

  var commonConstants = CommonConstants();
  var actionWidgetSize = 55.0;
  var plusIconSize = 14.0;

  UnitsMesurements? unitsMesurements;

  setValues(String? unitsTosearch, String range) async {
    await commonConstants
        .getValuesForUnit(unitsTosearch, range)
        .then((unitsMesurementsClone) {
      unitsMesurements = unitsMesurementsClone;
    });
  }

  Widget getPlusIcon(Function onTap) {
    return Positioned(
      bottom: 0,
      left: (55 / 2) - (55 / 2),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
            width: 14, // PlusIconSize = 20.0;

            height: 14, // PlusIconSize = 20.0;

            decoration: BoxDecoration(
                color: ColorUtils.countColor,
                borderRadius: BorderRadius.circular(15)),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 12,
            )),
      ),
    );
  }

  Widget getSaveButton(Function onSavedPressed, {String? text, double? width}) {
    return RaisedGradientButton(
      width: width ?? 120.0.w,
      height: 40.0.h,
      borderRadius: 30,
      gradient: LinearGradient(
        colors: <Color>[
          mAppThemeProvider.primaryColor,
          mAppThemeProvider.gradientColor
        ],
      ),
      onPressed: () {
        onSavedPressed();
      },
      child: Text(
        text ?? variable.strSave,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0.sp,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget getTextFieldForDialogWithControllerAndPressed(
      BuildContext context,
      Function(BuildContext context, String searchParam) onTextFieldtap,
      TextEditingController searchController,
      String searchParam) {
    return Container(
        width: 1.sw - 60,
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          onTap: () {
            onTextFieldtap(context, searchParam);
          },
          controller: searchController,
        ));
  }

  Widget getTextFieldWithNoCallbacks(
      BuildContext context, TextEditingController searchController,
      {bool? isFileField}) {
    return Container(
        width: 1.sw - 60,
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          enabled: isFileField ?? false,
          controller: searchController,
        ));
  }

  Widget getTextFieldWithNoCallbacksClaim(
      BuildContext context, TextEditingController searchController,
      {bool? isFileField}) {
    return Container(
        width: 1.sw,
        child: TextField(
            textCapitalization: TextCapitalization.sentences,
            enabled: isFileField ?? false,
            controller: searchController,
            style: getTextStyleForValue(),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 20.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            )));
  }

  getTextStyleForValue() {
    return TextStyle(color: Colors.black, fontSize: fhbStyles.fnt_category);
  }

  getTextStyleForTags() {
    return TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: fhbStyles.fnt_doc_specialist,
        color: Colors.grey[600]);
  }

  String currency(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    print("CURRENCY SYMBOL ${format.currencySymbol}"); // $
    print("CURRENCY NAME ${format.currencyName}");
    return format.currencySymbol; // USD
  }

  Widget getTextFieldWithNoCallbacksForMemo(
      BuildContext context, TextEditingController searchController) {
    return Container(
        width: 1.sw - 60,
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          maxLength: 500,
          controller: searchController,
        ));
  }

  Widget getTextForAlertDialog(BuildContext context, String hintText) {
    return Container(
        width: 1.sw - 60,
        child: Text(
          hintText,
          style: TextStyle(fontSize: 16.0.sp),
        ));
  }

  Widget getTextForAlertDialogClaim(BuildContext context, String hintText) {
    return Container(
        width: 1.sw - 80,
        child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              hintText,
              style: getTextStyleForTags(),
            )));
  }

  void showInSnackBar(String value, GlobalKey<ScaffoldMessengerState> scaffoldstate) {
    try {
      var snackBar = SnackBar(content: Text(value));
      // Using ScaffoldMessenger to show a SnackBar
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Widget getTextFieldForDate(
      BuildContext context,
      TextEditingController dateController,
      Function(DateTime dateTime, String selectedDate) onDateSelected) {
    return Container(
        width: 1.sw - 60,
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          onTap: () {},
          controller: dateController,
          decoration: InputDecoration(
              suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              return _selectDate(context, onDateSelected, dateTime);
            },
          )),
        ));
  }

  _selectDate(BuildContext context, onDateSelected, DateTime dateTime) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light().copyWith(
            primary: mAppThemeProvider.primaryColor,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null && picked != dateTime) {
      dateTime = picked;

      return onDateSelected(
          dateTime,
          DateFormat(CommonUtil.REGION_CODE == 'IN'
                  ? variable.strDateFormatDay
                  : variable.strUSDateFormatDay)
              .format(dateTime)
              .toString());
    }
  }

  Widget getTextFiledWithNoHInt(BuildContext context) {
    return Container(
        width: 1.sw - 60,
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          onTap: () {},
        ));
  }

  Widget getTextTextTitleWithPurpleColor(String textTitle, {double? fontSize}) {
    return Text(textTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: mAppThemeProvider.primaryColor,
            fontSize: fontSize ?? 20.0));
  }

  Widget getContainerWithNoDataText() {
    return Container(
      child: Center(
        child: Text(variable.strNoData),
      ),
    );
  }

  Widget getContainerFeatureDisableDataText() {
    return Container(
        child: Center(
      child: Text(strFeatureNotEnable, textAlign: TextAlign.center),
    ));
  }

  Widget getSnackBarWidget(BuildContext context, String msg) {
// Find the Scaffold in the widget tree and use it to show a SnackBar.
    return Container(
        child: Center(
      child: Text(msg),
    ));
  }

  Widget getProfilePicWidget(ProfilePicThumbnailMain profilePicThumbnail) {
    return profilePicThumbnail != null
        ? Image.memory(
            Uint8List.fromList(profilePicThumbnail.data!),
            height: 50.0.h,
            width: 50.0.h,
            fit: BoxFit.cover,
          )
        : Container(
            color: Color(fhbColors.bgColorContainer),
            height: 50.0.h,
            width: 50.0.h,
          );
  }

  Widget getProfilePicWidgeUsingUrl(MyProfileModel? myProfile,
      {bool? changeWhiteBg, double? textSize}) {
    if (myProfile != null && myProfile.result != null) {
      if (myProfile.result!.profilePicThumbnailUrl != '') {
        return Image.network(
          myProfile.result?.profilePicThumbnailUrl ?? '',
          height: CommonUtil().isTablet!
              ? imageProfileTabHeader
              : imageProfileMobileHeader,
          width: CommonUtil().isTablet!
              ? imageProfileTabHeader
              : imageProfileMobileHeader,
          fit: BoxFit.cover,
          headers: {
            HttpHeaders.authorizationHeader: authToken ?? "",
          },
          errorBuilder: (context, exception, stackTrace) {
            return Container(
              height: CommonUtil().isTablet!
                  ? imageProfileTabHeader
                  : imageProfileMobileHeader,
              width: CommonUtil().isTablet!
                  ? imageProfileTabHeader
                  : imageProfileMobileHeader,
              color: changeWhiteBg == true
                  ? Colors.white
                  : PreferenceUtil.getIfQurhomeisAcive()
                      ? CommonUtil.isUSRegion()
                          ? mAppThemeProvider.primaryColor
                          : mAppThemeProvider.qurhomeGradientColor
                      : mAppThemeProvider.primaryColor,
              child: Center(
                child: getFirstLastNameText(myProfile,
                    changeWhiteBg: changeWhiteBg),
              ),
            );
          },
        );
      } else {
        return Container(
          child: Center(
            child: getFirstLastNameTextForProfile(myProfile!,
                textColor: mAppThemeProvider.primaryColor),
          ),
          color: Color(fhbColors.bgColorContainer),
          height: CommonUtil().isTablet!
              ? imageProfileTabHeader
              : imageProfileMobileHeader,
          width: CommonUtil().isTablet!
              ? imageProfileTabHeader
              : imageProfileMobileHeader,
        );
      }
    } else {
      return Container(
        color: Color(fhbColors.bgColorContainer),
        height: CommonUtil().isTablet!
            ? imageProfileTabHeader
            : imageProfileMobileHeader,
        width: CommonUtil().isTablet!
            ? imageProfileTabHeader
            : imageProfileMobileHeader,
      );
    }
  }

  Future<String?> setAuthToken() async {
    authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
    return authToken;
  }

  Widget getDefaultProfileImage() {
    return Image.network(
      '',
      height: 50.0.h,
      width: 50.0.h,
    );
  }

  Widget getTextFiledWithHintAndSuffixText(
    BuildContext context,
    String hintTextValue,
    String? suffixTextValue,
    TextEditingController controllerValue,
    Function(String) onTextChanged,
    String error,
    String? unitsTosearch, {
    String? range,
    String? device,
    bool? showLabel,
  }) {
    var errorValue = error;
    if (showLabel == null) {
      showLabel = true;
    }
    setValues(unitsTosearch, range ?? '');

    return Container(
        width: 1.sw - 60,
        child: TextFormField(
          textCapitalization: TextCapitalization.sentences,
          onTap: () {},
          controller: controllerValue,
          inputFormatters: (device == Constants.STR_THERMOMETER ||
                  device == Constants.STR_WEIGHING_SCALE)
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))]
              : [
                  FilteringTextInputFormatter.digitsOnly,
                ],
          keyboardType: (device == Constants.STR_THERMOMETER ||
                  device == Constants.STR_WEIGHING_SCALE)
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          decoration: InputDecoration(
              hintText: hintTextValue,
              suffixText: showLabel ? suffixTextValue : '',
              errorText: errorValue == '' ? null : errorValue,
              errorMaxLines: 2),
          onChanged: (value) {
            commonConstants
                .getValuesForUnit(unitsTosearch, range)
                .then((unitsMesurementsClone) {
              unitsMesurements = unitsMesurementsClone;

              var number;
              if (device == Constants.STR_THERMOMETER) {
                number = double.parse(value);
              } else {
                number = int.parse(value);
              }
              if (number < unitsMesurements!.minValue ||
                  number > unitsMesurements!.maxValue) {
                errorValue = CommonConstants.strErrorStringForDevices +
                    ' ' +
                    unitsMesurements!.minValue.toString() +
                    variable.strAnd +
                    unitsMesurements!.maxValue.toString();

                onTextChanged(errorValue);
              } else {
                onTextChanged('');
              }
            });
          },
        ));
  }

  Widget getTextFiledWithHint(BuildContext context, String hintTextValue,
      TextEditingController? memoController,
      {bool? enabled,Widget? suffix,}) {
    return Container(
        width: 1.sw - 60,
        child: TextField(
            textCapitalization: TextCapitalization.sentences,
            enabled: enabled ?? true,
            onTap: () {},
            controller: memoController,
            decoration: InputDecoration(
              hintText: hintTextValue,
              suffixIcon: suffix
            )));
  }

  Widget getMicIcon(BuildContext context, bool containsAudio, String? audioPath,
      Function(bool containsAudio, String? audioPath) updateUI) {
    return GestureDetector(
      child: Container(
        height: 80.0.h,
        width: 80.0.h,
        padding: EdgeInsets.all(10),
        child: Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: CircleBorder(),
          child: CircleAvatar(
            //backgroundColor: Colors.transparent,
            backgroundColor: ColorUtils.greycolor,
            radius: 30.0.sp,
            child: Icon(
              Icons.mic,
              size: 40.0.sp,
              color: mAppThemeProvider.primaryColor,
            ),
          ),
        ),
      ),
      onTap: () async {
        await Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => AudioRecorder(
              arguments: AudioScreenArguments(fromVoice: false),
            ),
          ),
        )
            .then(
          (results) {
            if (results != null) {
              if (results.containsKey(Constants.keyAudioFile)) {
                containsAudio = true;
                audioPath = results[Constants.keyAudioFile];
                updateUI(containsAudio, audioPath);
              }
            }
          },
        );
      },
    );
  }

  Widget getAudioIconWithFile(
      String? audioPathMain,
      bool containsAudioMain,
      Function(bool containsAudio, String? audioPath) updateUI,
      BuildContext context,
      List<String?>? imagePath,
      Function(BuildContext context, List<String?>? imagePath)
          onPostDataToServer) {
    return containsAudioMain
        ? Column(
            children: <Widget>[
              AudioWidget(audioPathMain, (containsAudio, audioPath) {
                audioPathMain = audioPath;
                containsAudioMain = containsAudio;

                updateUI(containsAudioMain, audioPathMain);
              }),
              Padding(
                padding: const EdgeInsets.all(8),
              ),
              getSaveButton(() {
                onPostDataToServer(context, imagePath);
              })
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getMicIcon(context, containsAudioMain, audioPathMain,
                  (containsAudio, audioPath) {
                audioPathMain = audioPath;
                containsAudioMain = containsAudio;
                updateUI(containsAudioMain, audioPathMain);
              }),
              getSaveButton(() {
                onPostDataToServer(context, imagePath);
              })
            ],
          );
  }

  Widget getAudioWidgetForChat(String? audioPathMain) {
    return Column(
      children: <Widget>[AudioWidget(audioPathMain, null, isFromChat: true)],
    );
  }

  Widget getPopmenuItem(Doctors element, Function onAddClick) {
    return PopupMenuItem<Doctors>(
        value: element,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: 0.5.sw,
              child: Text(
                element.user!.name!,
              ),
            ),
            SizedBox(height: 10),
            getSaveButton(() {
              onAddClick();
            }, text: 'Add Doctor'),
            SizedBox(height: 10),
          ],
        ));
  }

  Future<bool> exitApp(BuildContext context, Function logout) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          variable.strLogout,
          style: TextStyle(
              fontSize: 16.0.sp,
              color: mAppThemeProvider.primaryColor),
        ),
        content: Text(
          variable.strLogoutMsg,
          style: TextStyle(fontSize: 16.0.sp),
        ),
        actions: <Widget>[
          FlatButtonWidget(
            bgColor: Colors.transparent,
            isSelected: true,
            onPress: () {
              Navigator.of(context).pop(false);
            },
            title: variable.Cancel,
            titleColor: mAppThemeProvider.primaryColor,
          ),
          FlatButtonWidget(
            bgColor: Colors.transparent,
            isSelected: true,
            onPress: () {
              logout();
            },
            title: variable.strYes,
            titleColor: mAppThemeProvider.primaryColor,
          ),
        ],
      ),
    ).then((value) => value as bool);
  }

  static customShowCaseNew(
      GlobalKey _key, String desc, Widget _child, String title,
      {required BuildContext context}) {
    return Showcase.withWidget(
        key: _key,
        disableAnimation: true,
        shapeBorder: CircleBorder(),
        title: title,
        description: desc,
        child: _child,
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        height: MediaQuery.of(context).size.height - 200,
        width: MediaQuery.of(context).size.width,
        container: Container(
            height: 120.0.h,
            margin: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 24,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 110.0.h,
                  width: 320.0.w,
                  margin: EdgeInsets.only(left: 40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      mAppThemeProvider.primaryColor,
                      mAppThemeProvider.gradientColor
                    ]),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(left: 40, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.0.sp),
                            softWrap: true,
                          ),
                          SizedBox(height: 5.0.h),
                          Text(
                            desc,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white, fontSize: 15.0.sp),
                            softWrap: true,
                          ),
                        ],
                      )),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  padding: EdgeInsets.all(4),
                  alignment: FractionalOffset.centerLeft,
                  child: Image(
                    image: AssetImage(variable.icon_mayaMain),
                    height: 80.0.h,
                    width: 80.0.h,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
              ],
            )));
  }

  static customShowCase(
      GlobalKey? _key, String desc, Widget _child, String title) {
    return Showcase.withWidget(
        key: _key!,
        disableAnimation: false,
        shapeBorder: CircleBorder(),
        title: title,
        description: desc,
        child: _child,
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        height: 1.h,
        width: double.infinity,
        container: Container(
            height: 120.0.h,
            margin: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 24,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 110.0.h,
                  width: 320.0.w,
                  margin: EdgeInsets.only(left: 40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      mAppThemeProvider.primaryColor,
                      mAppThemeProvider.gradientColor
                    ]),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(left: 40, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.0.sp),
                            softWrap: true,
                          ),
                          SizedBox(height: 5.0.h),
                          Text(
                            desc,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white, fontSize: 15.0.sp),
                            softWrap: true,
                          ),
                        ],
                      )),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: CommonUtil().isTablet! ? 15 : 30),
                  padding: EdgeInsets.all(4),
                  alignment: FractionalOffset.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Image(
                    image: AssetImage(variable.icon_mayaMain),
                    height: CommonUtil().isTablet! ? 65 : 80.0.h,
                    width: CommonUtil().isTablet! ? 65 : 80.0.h,
                  ),
                ),
              ],
            )));
  }

  static Widget getRefreshContainerButton(
      String? errorMsg, Function onRefreshPressed) {
    return ErrorsWidget();
    // return Container(
    //   color: Color(fhbColors.bgColorContainer),
    //   padding: EdgeInsets.only(left: 20, right: 20),
    //   alignment: Alignment.center,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Text(errorMsg,
    //           style: TextStyle(
    //             fontSize: 15.0.sp,
    //           )),
    //     ],
    //   ),
    // );
  }

  Future<bool> showDialogWithTwoButtons(
      BuildContext context, Function logout, String title, String msg) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16.0.sp,
              color: mAppThemeProvider.primaryColor),
        ),
        content: Text(
          msg,
          style: TextStyle(fontSize: 16.0.sp),
        ),
        actions: <Widget>[
          FlatButtonWidget(
            bgColor: Colors.transparent,
            isSelected: true,
            onPress: () {
              Navigator.of(context).pop(false);
            },
            title: variable.Cancel,
            titleColor: mAppThemeProvider.primaryColor,
          ),
          FlatButtonWidget(
            bgColor: Colors.transparent,
            isSelected: true,
            onPress: () {
              logout();
            },
            title: variable.strYes,
            titleColor: mAppThemeProvider.primaryColor,
          ),
        ],
      ),
    ).then((value) => value as bool);
  }

  Widget getRichTextFieldWithNoCallbacks(
      BuildContext context,
      TextEditingController searchController,
      String hintText,
      int length,
      String? error,
      Function(String?) onTextChanged,
      bool condiiton) {
    String? errorValue = error;

    return Container(
      height: 1.sh / 5,
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            errorText: errorValue == '' ? null : errorValue,
            errorMaxLines: 2,
            disabledBorder:
                OutlineInputBorder(borderSide: BorderSide(width: 5)),
            hintStyle: TextStyle(fontSize: 15.0.sp),
            hintText: hintText,
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 5.0.w),
                borderRadius: BorderRadius.circular(7))),
        controller: searchController,
        maxLength: length,
        maxLines: 4,
        onChanged: (value) {
          if (condiiton) {
            if (value.length > 0) {
              errorValue = error;

              onTextChanged(errorValue);
            }
          }
        },
      ),
    );
  }

  Widget getErrorMsgForUnitEntered(
      BuildContext context,
      String hintTextValue,
      String? suffixTextValue,
      TextEditingController controllerValue,
      Function(String) onTextChanged,
      String error,
      String? unitsTosearch,
      String? deviceName,
      {String? range,
      String? device}) {
    var node = FocusScope.of(context);

    setValues(unitsTosearch, range ?? '');

    var valueEnterd = '';
    var errorValue = error;
    return Container(
        width: 50.0.w,
        child: TextFormField(
          textCapitalization: TextCapitalization.sentences,
          textAlign: TextAlign.center,
          maxLength: deviceName == Constants.STR_THERMOMETER
              ? 4
              : deviceName == Constants.STR_WEIGHING_SCALE
                  ? 6
                  : 3,
          style: TextStyle(
              fontSize: 15.0.sp,
              fontWeight: FontWeight.w500,
              color: getColorBasedOnDevice(
                  deviceName, unitsTosearch, controllerValue.text.toString())),
          onTap: () {},
          controller: controllerValue,
          onEditingComplete: () {
            if (checkifValueisInRange(
                controllerValue.text.toString(), device)) {
              Alert.displayConfirmProceed(context,
                  title: 'Confirmation',
                  content: CommonConstants.strErrorStringForDevices +
                      ' ' +
                      unitsMesurements!.minValue.toString() +
                      variable.strAnd +
                      unitsMesurements!.maxValue.toString(),
                  confirm: 'Confirm', onPressedConfirm: () {
                Navigator.pop(context);
                node.nextFocus();
              }, onPressedCancel: () {
                controllerValue.text = '';
                Navigator.pop(context);
              });
            } else {
              node.nextFocus();
            }
          },
          // Move focus to next
          decoration: InputDecoration(
              counterText: '',
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: getColorBasedOnDevice(deviceName, unitsTosearch, ''),
                    width: 0.5.w),
              ),
              hintText: '0',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0.sp),
              contentPadding: EdgeInsets.zero),
          cursorColor: getColorBasedOnDevice(deviceName, unitsTosearch, ''),
          inputFormatters: (deviceName == Constants.STR_THERMOMETER ||
                  deviceName == Constants.STR_WEIGHING_SCALE)
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))]
              : [FilteringTextInputFormatter.digitsOnly],
          keyboardType: (deviceName == Constants.STR_THERMOMETER ||
                  deviceName == Constants.STR_WEIGHING_SCALE)
              ? TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,

          cursorWidth: 0.5.w,
          onChanged: (value) {
            //setValues(unitsTosearch,range);
            commonConstants
                .getValuesForUnit(unitsTosearch, range)
                .then((unitsMesurementsClone) {
              unitsMesurements = unitsMesurementsClone;

              if (value.length < 4) {
                valueEnterd = value;
                var number;
                if (device == "Temp" ||
                    deviceName == Constants.STR_WEIGHING_SCALE) {
                  number = double.parse(value);
                } else {
                  number = int.parse(value);
                }
                if (number is int) {
                  if (number < unitsMesurements!.minValue ||
                      number > unitsMesurements!.maxValue) {
                    errorValue = CommonConstants.strErrorStringForDevices +
                        ' ' +
                        unitsMesurements!.minValue.toString() +
                        variable.strAnd +
                        unitsMesurements!.maxValue.toString();

                    onTextChanged(errorValue);
                  }
                } else if (number is double) {
                  if (number < ((unitsMesurements?.minValue).toDouble()) ||
                      number > ((unitsMesurements?.maxValue).toDouble())) {
                    errorValue = CommonConstants.strErrorStringForDevices +
                        ' ' +
                        unitsMesurements!.minValue.toString() +
                        variable.strAnd +
                        unitsMesurements!.maxValue.toString();

                    onTextChanged(errorValue);
                  }
                }
              } else if ((deviceName == Constants.STR_THERMOMETER ||
                      deviceName == Constants.STR_WEIGHING_SCALE) &&
                  value.length < 5) {
                valueEnterd = value;
                var number;
                if (device == "Temp" ||
                    deviceName == Constants.STR_WEIGHING_SCALE) {
                  number = double.parse(value);
                } else {
                  number = int.parse(value);
                }
                try {
                  if (number is int) {
                    if (number < unitsMesurements!.minValue ||
                        number > unitsMesurements!.maxValue) {
                      errorValue = CommonConstants.strErrorStringForDevices +
                          ' ' +
                          unitsMesurements!.minValue.toString() +
                          variable.strAnd +
                          unitsMesurements!.maxValue.toString();

                      onTextChanged(errorValue);
                    }
                  } else if (number is double) {
                    if (number < ((unitsMesurements!.minValue).toDouble()) ||
                        number > ((unitsMesurements!.maxValue).toDouble())) {
                      errorValue = CommonConstants.strErrorStringForDevices +
                          ' ' +
                          unitsMesurements!.minValue.toString() +
                          variable.strAnd +
                          unitsMesurements!.maxValue.toString();

                      onTextChanged(errorValue);
                    }
                  }
                } catch (e, stackTrace) {
                  CommonUtil().appLogs(message: e, stackTrace: stackTrace);

                  onTextChanged('');
                }
              } else {
                if (checkifValueisInRange(
                    controllerValue.text.toString(), deviceName ?? "")) {
                  Alert.displayConfirmProceed(context,
                      title: 'Confirmation',
                      content: CommonConstants.strErrorStringForDevices +
                          ' ' +
                          unitsMesurements!.minValue.toString() +
                          variable.strAnd +
                          unitsMesurements!.maxValue.toString(),
                      confirm: 'Confirm', onPressedConfirm: () {
                    Navigator.pop(context);
                    node.nextFocus();
                  }, onPressedCancel: () {
                    controllerValue.text = '';
                    Navigator.pop(context);
                  });
                } else {
                  node.nextFocus();
                }
              }
            });
          },
        ));
  }

  showPopupForNotInRange() {}

  getColorBasedOnDevice(
      String? deviceName, String? unitsTosearch, String text) {
    switch (deviceName) {
      case Constants.STR_BP_MONITOR:
        if (text != null && text != '') {
          final number = int.parse(text);
          if (number < unitsMesurements!.minValue ||
              number > unitsMesurements!.maxValue) {
            return Colors.red;
          } else {
            return Color(CommonConstants.bpDarkColor);
          }
        } else {
          return Color(CommonConstants.bpDarkColor);
        }
        break;
      case Constants.STR_GLUCOMETER:
        if (text != null && text != '') {
          final number = int.parse(text);
          if (number < unitsMesurements!.minValue ||
              number > unitsMesurements!.maxValue) {
            return Colors.red;
          } else {
            return Color(CommonConstants.GlucoDarkColor);
          }
        } else {
          return Color(CommonConstants.GlucoDarkColor);
        }
        break;
      case Constants.STR_WEIGHING_SCALE:
        if (text != null && text != '') {
          final number = double.parse(text);
          if (number is int) {
            if (number < unitsMesurements!.minValue ||
                number > unitsMesurements!.maxValue) {
              return Colors.red;
            } else {
              return Color(CommonConstants.weightDarkColor);
            }
          } else if (number is double) {
            if (number < (unitsMesurements!.minValue).toDouble() ||
                number > (unitsMesurements!.maxValue).toDouble()) {
              return Colors.red;
            } else {
              return Color(CommonConstants.weightDarkColor);
            }
          }
        } else {
          return Color(CommonConstants.weightDarkColor);
        }
        break;

      case Constants.STR_THERMOMETER:
        if (text != null && text != '') {
          final number = double.parse(text);
          if (number < unitsMesurements!.minValue ||
              number > unitsMesurements!.maxValue) {
            return Colors.red;
          } else {
            return Color(CommonConstants.ThermoDarkColor);
          }
        } else {
          return Color(CommonConstants.ThermoDarkColor);
        }
        break;

      case Constants.STR_PULSE_OXIMETER:
        if (text != null && text != '') {
          final number = int.parse(text);
          if (number < unitsMesurements!.minValue ||
              number > unitsMesurements!.maxValue) {
            return Colors.red;
          } else {
            return Color(CommonConstants.pulseDarkColor);
          }
        } else {
          return Color(CommonConstants.pulseDarkColor);
        }
        break;
      default:
        if (text != null && text != '') {
          final number = int.parse(text);
          if (number < unitsMesurements!.minValue ||
              number > unitsMesurements!.maxValue) {
            return Colors.red;
          } else {
            return Color(CommonConstants.pulseDarkColor);
          }
        } else {
          return Color(CommonConstants.pulseDarkColor);
        }
        break;
    }
  }

  checkifValueisInRange(String text, String? device) {
    try {
      if (text != null && text != '') {
        var number;
        if (device == "Temp" || device == Constants.STR_WEIGHING_SCALE) {
          number = double.parse(text);
        } else {
          number = int.parse(text);
        }
        if (number is int) {
          if (number < unitsMesurements!.minValue ||
              number > unitsMesurements!.maxValue) {
            return true;
          } else {
            return false;
          }
        } else if (number is double) {
          if (number < (unitsMesurements!.minValue).toDouble() ||
              number > (unitsMesurements!.maxValue).toDouble()) {
            return true;
          } else {
            return false;
          }
        }
      } else {
        return false;
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return false;
    }
  }
}

double nameTextSize = (CommonUtil().isTablet! ? tabHeader4 : mobileHeader1);
double nameTextSizeForNav = (CommonUtil().isTablet!
    ? tabHeader1
    : mobileHeader1); //declare size of the text inside the profile image

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int? decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    var newSelection = newValue.selection;
    var truncated = newValue.text;

    if (decimalRange != null) {
      var value = newValue.text;

      if (value.contains('.') &&
          value.substring(value.indexOf('.') + 1).length > decimalRange!) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == '.') {
        truncated = '0.';

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
      );
    }
    return newValue;
  }
}

Widget getFirstLastNameText(MyProfileModel myProfile, {bool? changeWhiteBg}) {
  if (myProfile.result != null &&
      myProfile.result!.firstName != null &&
      myProfile.result!.lastName != null) {
    return Text(
      myProfile.result!.firstName![0].toUpperCase() +
          (myProfile.result!.lastName!.length > 0
              ? myProfile.result!.lastName![0].toUpperCase()
              : ''),
      style: TextStyle(
        color: changeWhiteBg == true
            ? mAppThemeProvider.primaryColor
            : Colors.white,
        fontSize: nameTextSize,
        fontWeight: FontWeight.w400,
      ),
    );
  } else if (myProfile.result != null && myProfile.result!.firstName != null) {
    return Text(
      myProfile.result!.firstName![0].toUpperCase(),
      style: TextStyle(
        color: changeWhiteBg == true
            ? mAppThemeProvider.primaryColor
            : Colors.white,
        fontSize: nameTextSize,
        fontWeight: FontWeight.w400,
      ),
    );
  } else {
    return Text(
      '',
      style: TextStyle(
        color: changeWhiteBg == true
            ? mAppThemeProvider.primaryColor
            : Colors.white,
        fontSize: nameTextSize,
        fontWeight: FontWeight.w200,
      ),
    );
  }
}

Widget getFirstLastNameTextForProfile(MyProfileModel myProfile,
    {Color? textColor, double? textSize, bool? forNavdrawer = false}) {
  if (myProfile.result != null &&
      myProfile.result!.firstName != null &&
      myProfile.result!.lastName != null) {
    return Text(
      myProfile.result!.firstName![0].toUpperCase() +
          (myProfile.result!.lastName!.length > 0
              ? myProfile.result!.lastName![0].toUpperCase()
              : ''),
      style: TextStyle(
        color: textColor ?? Colors.white,
        fontSize: textSize ??
            ((forNavdrawer ?? false) ? nameTextSizeForNav : nameTextSize),
        fontWeight: FontWeight.w500,
      ),
    );
  } else if (myProfile.result != null && myProfile.result!.firstName != null) {
    return Text(
      myProfile.result!.firstName![0].toUpperCase(),
      style: TextStyle(
        color: Colors.white,
        fontSize: ((forNavdrawer ?? false) ? nameTextSizeForNav : nameTextSize),
        fontWeight: FontWeight.w500,
      ),
    );
  } else {
    return Text(
      '',
      style: TextStyle(
        color: mAppThemeProvider.primaryColor,
        fontSize: ((forNavdrawer ?? false) ? nameTextSizeForNav : nameTextSize),
        fontWeight: FontWeight.w200,
      ),
    );
  }
}
