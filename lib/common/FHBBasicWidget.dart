import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/AudioWidget.dart';
import 'package:myfhb/database/model/UnitsMesurement.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:showcaseview/showcase.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

import 'CommonConstants.dart';

class FHBBasicWidget {
  FHBBasicWidget();

  DateTime dateTime = DateTime.now();

  Widget getSaveButton(Function onSavedPressed) {
    return RaisedGradientButton(
      width: 120,
      height: 40,
      child: Text(
        'Save',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      borderRadius: 30,
      gradient: LinearGradient(
        colors: <Color>[
          //Colors.deepPurple[300], Colors.deepPurple
          Color(new CommonUtil().getMyPrimaryColor()),
          Color(new CommonUtil().getMyGredientColor())
        ],
      ),
      onPressed: () {
        onSavedPressed();
      },
    );
  }

  Widget getTextFieldForDialogWithControllerAndPressed(
      BuildContext context,
      Function(BuildContext context, String searchParam) onTextFieldtap,
      TextEditingController searchController,
      String searchParam) {
    return Container(
        width: MediaQuery.of(context).size.width - 60,
        child: TextField(
          autofocus: false,
          onTap: () {
            onTextFieldtap(context, searchParam);
            //moveToSearchScreen(context, 'Doctors');
          },
          controller: searchController,
        ));
  }

  Widget getTextFieldWithNoCallbacks(
      BuildContext context, TextEditingController searchController) {
    return Container(
        width: MediaQuery.of(context).size.width - 60,
        child: TextField(
          autofocus: false,
          controller: searchController,
        ));
  }

  Widget getTextForAlertDialog(BuildContext context, String hintText) {
    return Container(
        width: MediaQuery.of(context).size.width - 60,
        child: Text(
          hintText,
          style: TextStyle(fontSize: 14),
        ));
  }

  void showInSnackBar(String value, GlobalKey<ScaffoldState> scaffoldstate) {
    final snackBar = SnackBar(content: Text(value));
    scaffoldstate.currentState.showSnackBar(snackBar);
  }

  Widget getTextFieldForDate(
      BuildContext context,
      TextEditingController dateController,
      Function(DateTime dateTime, String selectedDate) onDateSelected) {
    return Container(
        width: MediaQuery.of(context).size.width - 60,
        child: TextField(
          autofocus: false,
          onTap: () {},
          controller: dateController,
          decoration: InputDecoration(
              suffixIcon: new IconButton(
            icon: new Icon(Icons.calendar_today),
            onPressed: () {
              return _selectDate(context, onDateSelected, dateTime);
            },
          )),
        ));
  }

  _selectDate(BuildContext context, onDateSelected, DateTime dateTime) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != dateTime) {
      dateTime = picked ?? dateTime;

      print('setstate' +
          new DateFormat("dd/MM/yyyy").format(dateTime).toString());

      return onDateSelected(
          dateTime, new DateFormat("dd/MM/yyyy").format(dateTime).toString());
    }
  }

  Widget getTextFiledWithNoHInt(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 60,
        child: TextField(
          autofocus: false,
          onTap: () {},
        ));
  }

  Widget getTextTextTitleWithPurpleColor(String textTitle) {
    return Text(
      textTitle,
      textAlign: TextAlign.center,
      style: TextStyle(color: Color(new CommonUtil().getMyPrimaryColor())),
    );
  }

  Widget getContainerWithNoDataText() {
    return Container(
      child: Center(
        child: Text('No data Available'),
      ),
    );
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
            Uint8List.fromList(profilePicThumbnail.data),
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          )
        : Container(
            color: Colors.white,
            height: 50,
            width: 50,
          );
  }

  Widget getDefaultProfileImage() {
    return Image.network(
      'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
      height: 50,
      width: 50,
    );
  }

  Widget getTextFiledWithHintAndSuffixText(
      BuildContext context,
      String hintTextValue,
      String suffixTextValue,
      TextEditingController controllerValue,
      Function(String) onTextChanged,
      String error,
      String unitsTosearch) {
    var commonConstants = new CommonConstants();

    UnitsMesurements unitsMesurements;
    commonConstants
        .getValuesForUnit(unitsTosearch)
        .then((unitsMesurementsClone) {
      unitsMesurements = unitsMesurementsClone;
    });

    String errorValue = error;
    return Container(
        width: MediaQuery.of(context).size.width - 60,
        child: TextField(
          autofocus: false,
          onTap: () {},
          controller: controllerValue,
          decoration: InputDecoration(
              hintText: hintTextValue,
              suffixText: suffixTextValue,
              errorText: errorValue == '' ? null : errorValue,
              errorMaxLines: 2),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            var number = int.parse(value);
            if (number < unitsMesurements.minValue ||
                number > unitsMesurements.maxValue) {
              errorValue = CommonConstants.strErrorStringForDevices +
                  ' ' +
                  unitsMesurements.minValue.toString() +
                  ' and ' +
                  unitsMesurements.maxValue.toString();

              onTextChanged(errorValue);
            } else {
              onTextChanged('');
            }
          },
        ));
  }

  Widget getTextFiledWithHint(BuildContext context, String hintTextValue,
      TextEditingController memoController) {
    return Container(
        width: MediaQuery.of(context).size.width - 60,
        child: TextField(
            autofocus: false,
            onTap: () {},
            controller: memoController,
            decoration: InputDecoration(
              hintText: hintTextValue,
            )));
  }

  Widget getMicIcon(BuildContext context, bool containsAudio, String audioPath,
      Function(bool containsAudio, String audioPath) updateUI) {
    return GestureDetector(
      child: Container(
        height: 80,
        width: 80,
        padding: EdgeInsets.all(10),
        child: Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: CircleBorder(),
          child: CircleAvatar(
            //backgroundColor: Colors.transparent,
            backgroundColor: ColorUtils.greycolor,
            child: Icon(Icons.mic,
                size: 40, color: Color(CommonUtil().getMyPrimaryColor())),
            radius: 30.0,
          ),
        ),
      ),
      onTap: () async {
        await Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) => AudioRecordScreen(fromVoice: false),
        ))
            .then((results) {
          if (results != null) {
            if (results.containsKey('audioFile')) {
              containsAudio = true;
              audioPath = results['audioFile'];
              print('Audio Path' + audioPath);
              print('Audio Path' + containsAudio.toString());

              updateUI(containsAudio, audioPath);
            }
          }
        });
      },
    );
  }

  Widget getAudioIconWithFile(
      String audioPathMain,
      bool containsAudioMain,
      Function(bool containsAudio, String audioPath) updateUI,
      BuildContext context,
      List<String> imagePath,
      Function(BuildContext context, List<String> imagePath)
          onPostDataToServer) {
    return containsAudioMain
        ? Column(
            children: <Widget>[
              new AudioWidget(audioPathMain, (containsAudio, audioPath) {
                audioPathMain = audioPath;
                containsAudioMain = containsAudio;

                updateUI(containsAudioMain, audioPathMain);
              }),
              Padding(
                padding: const EdgeInsets.all(8.0),
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

  Future<bool> exitApp(BuildContext context, Function logout) {
    return showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
              'Logout',
              style: TextStyle(
                  fontSize: 16, color: Color(CommonUtil().getMyPrimaryColor())),
            ),
            content: Text(
              'Stay Healthy.. See you Soon. \nMaya will be waiting to serve you.',
              style: TextStyle(fontSize: 14),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  //print("you choose no");
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Color(CommonUtil().getMyPrimaryColor()))),
              ),
              FlatButton(
                onPressed: () {
                  logout();
                },
                child: Text('Yes',
                    style: TextStyle(
                        color: Color(CommonUtil().getMyPrimaryColor()))),
              ),
            ],
          ),
        ) ??
        false;
  }

  static customShowCase(
      GlobalKey _key, String desc, Widget _child, String title) {
    return Showcase.withWidget(
        key: _key,
        disableAnimation: false,
        shapeBorder: CircleBorder(),
        title: title,
        description: desc,
        child: _child,
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        height: double.infinity,
        width: double.infinity,
        container: Container(
            height: 120.0,
            margin: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
            child: new Stack(
              children: <Widget>[
                Container(
                  height: 110.0,
                  width: 320,
                  margin: new EdgeInsets.only(left: 40.0),
                  child: Padding(
                      padding: EdgeInsets.only(left: 40, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            softWrap: true,
                          ),
                          SizedBox(height: 5),
                          Text(
                            desc,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.white, fontSize: 13),
                            softWrap: true,
                          ),
                        ],
                      )),
                  decoration: new BoxDecoration(
                    //color: Colors.white,
                    gradient: LinearGradient(colors: [
                      Color(CommonUtil().getMyPrimaryColor()),
                      Color(CommonUtil().getMyGredientColor())
                    ]),
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.circular(8.0),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: new Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: new EdgeInsets.symmetric(vertical: 30.0),
                  padding: EdgeInsets.all(4),
                  alignment: FractionalOffset.centerLeft,
                  child: new Image(
                    image: new AssetImage('assets/maya/maya_us_main.png'),
                    height: 80.0,
                    width: 80.0,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                ),
              ],
            ))

        /* Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/maya/maya_us.png',
              height: 80,
              width: 80,
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    desc,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Color(CommonUtil().getMyPrimaryColor()),
                        fontFamily: 'Poppins'),
                    maxLines: 2,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  desc,
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(CommonUtil().getMyPrimaryColor()),
                      fontFamily: 'Poppins'),
                  softWrap: true,
                ),
              ],
            )
          ],
        ),
      ), */
        );
  }

  static Widget getRefreshContainerButton(
      String errorMsg, Function onRefreshPressed) {
    return Container(
      color: Color(fhbColors.bgColorContainer),
      padding: EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(errorMsg,
              style: TextStyle(
                fontSize: 13,
              )),
          /*  FlatButton(
              onPressed: () {
                onRefreshPressed();
              },
              child: Text(
                'Refresh',
                style: TextStyle(
                    color: Color(new CommonUtil().getMyPrimaryColor()),
                    fontWeight: FontWeight.w600),
              )),
        */
        ],
      ),
    );
  }
}
