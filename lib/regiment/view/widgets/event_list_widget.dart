import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import '../../models/profile_response_model.dart';
import 'event_time_tile.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../models/save_response_model.dart';
import 'package:provider/provider.dart';
import '../../view_model/regiment_view_model.dart';

class EventListWidget extends StatelessWidget {
  EventListWidget({
    @required this.profileResultModel,
  });

  final ProfileResultModel profileResultModel;
  final _formKey = GlobalKey<FormState>();
  var eventTime = {};
  var eventController = {};
  bool isEventsAreValid = true;
  List tempEventList = [];

  @override
  Widget build(BuildContext context) {
    var saveMap = <String, dynamic>{};
    return WillPopScope(
      onWillPop: () => Future<bool>.value(false),
      child: Form(
        key: _formKey,
        child: SimpleDialog(
          children: getDialogItems(
            onTimeSelected: (timeSelected, scheduleName, controller) {
              //tempEventList = eventTime.values.toList();
              final eventControllerList = eventController.values.toList();
              var currentIndex = eventTime.keys.toList().indexOf(scheduleName);
              tempEventList[currentIndex] = toDouble(timeSelected);
              eventControllerList[currentIndex].text =
                  getTimeAsString(timeSelected);
              final isValid = eventTimeValidation(tempEventList);
              /* if(currentIndex<tempEventList.length-1 && currentIndex<eventControllerList.length-1){
                if(currentIndex==0){
                  //do nothing
                }else if(tempEventList[currentIndex] > tempEventList[currentIndex+1]){
                  FlutterToast().getToast(
              '${tempEventList[currentIndex+1]} time should be greater than the ${tempEventList[currentIndex]} event',
              Colors.red);
                  for(int i = currentIndex;i<eventControllerList.length;i++){
                    eventControllerList[i].clear();
                  }

                  for (int j = tempEventList.length-1;j>=currentIndex;j--){
                    tempEventList[j]=0.0;
                  }
                }else if(tempEventList[currentIndex] == tempEventList[currentIndex+1]){
                  FlutterToast().getToast(
              '${tempEventList)[currentIndex+1]} time should be greater than the ${tempEventList[currentIndex]} event',
              Colors.red);
                  for(int i = currentIndex;i<eventControllerList.length;i++){
                    eventControllerList[i].clear();
                  }

                  for (int j = tempEventList.length-1;j>=currentIndex;j--){
                    tempEventList[j]=0.0;
                  }
                }
              }else{
                //do nothing
              } */
              final oldValue = saveMap.putIfAbsent(
                scheduleName,
                () => getTimeAsString(timeSelected),
              );
              if (oldValue != null) {
                saveMap[scheduleName] = getTimeAsString(timeSelected);
              }
            },
            onSave: () async {
              if (_formKey.currentState.validate()) {
                final isValid = eventTimeValidation(tempEventList);
                if (isValid) {
                  var currentLanguage = '';
                  var lan = CommonUtil.getCurrentLanCode();
                  if (lan != 'undef') {
                    var langCode = lan.split('-').first;
                    currentLanguage = langCode;
                  } else {
                    currentLanguage = 'en';
                  }
                  var schedules = '&Language=$currentLanguage';
                  saveMap.forEach((key, value) {
                    schedules += '&$key=$value';
                  });
                  var saveResponse = await Provider.of<RegimentViewModel>(
                          context,
                          listen: false)
                      .saveProfile(
                    schedules: schedules,
                  );
                  if (saveResponse?.isSuccess ?? false) {
                    FlutterToast().getToast(
                        'Regimen will be updated from the next day',
                        Colors.green);
                    Navigator.pop(context, true);
                    // if (Provider.of<RegimentViewModel>(context, listen: false).regimentStatus == RegimentStatus.DialogOpened) {
                    //   Navigator.pop(context, true);
                    // }else{
                    //   Navigator.pop(context, true);
                    // }
                  }
                }
              } else {
                FlutterToast()
                    .getToast('event time should\'t be empty', Colors.red);
              }
            },
          ),
          contentPadding: EdgeInsets.all(10.0.sp),
        ),
      ),
    );
  }

  List<Widget> getDialogItems({
    Function onTimeSelected,
    Function onSave,
  }) {
    var dialogItems = <Widget>[];

    dialogItems.add(
      Container(
        height: 45.0.h,
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                scheduleTitle,
                style: TextStyle(
                  fontSize: 16.0.sp,
                  color: Color(CommonUtil().getMyPrimaryColor()),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                size: 24.0.sp,
              ),
              onPressed: () => Navigator.pop(Get.context),
            ),
          ],
        ),
      ),
    );

    try {
      profileResultModel?.profileDataKeyList?.forEach(
        (listKey) {
          if (profileResultModel?.profileDataMap?.containsKey(listKey) ??
              false) {
            var key = listKey;
            var value = profileResultModel?.profileDataMap[listKey] ?? '00:00';
            final List<String> timeData = value?.split(':');
            if (timeData.length == 2) {
              eventTime[key] = toDouble(
                TimeOfDay(
                  hour: int.parse(timeData[0]),
                  minute: int.parse(timeData[1]),
                ),
              );
              final controllerName = TextEditingController();
              eventController[key] = controllerName;
              dialogItems.add(
                EventTimeTile(
                  title: key,
                  selectedTime: TimeOfDay(
                    hour: int.parse(timeData[0]),
                    minute: int.parse(timeData[1]),
                  ),
                  onTimeSelected: onTimeSelected,
                  controller: controllerName,
                ),
              );
            }
          }
        },
      );

      tempEventList.addAll(eventTime.values.toList());
      dialogItems.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150.0.w,
              child: RaisedButton(
                onPressed: onSave,
                color: Color(CommonUtil().getMyPrimaryColor()),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                    5.0.sp,
                  )),
                ),
                child: Text(
                  confirmButton,
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {}

    return dialogItems;
  }

  getTimeAsString(TimeOfDay timeOfDay) {
    var hour = timeOfDay?.hour;
    return '${hour > 9 ? '' : '0'}$hour:${timeOfDay.minute > 9 ? '' : '0'}${timeOfDay.minute}';
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  bool eventTimeValidation(List eventList,
      {String eventName, double currentEventTime}) {
    final eventNames = eventTime.keys.toList();
    for (var i = 0; i < eventList.length; i++) {
      if (i + 1 == eventList.length) {
        return true;
      } else if (eventList[i] > eventList[i + 1]) {
        if (i + 1 == eventList.length - 1) {
          FlutterToast().getToast(
              '${eventNames.last} time to be lesser than or equal to \'11.59\' PM',
              Colors.red);
        } else {
          FlutterToast().getToast(
              //'${eventNames[i + 1]} time should be greater than the ${eventNames[i]} event',
              'Please set a later time than ${eventNames[i]} time',
              Colors.red);
        }
        return false;
      } else if (eventList[i] == eventList[i + 1]) {
        FlutterToast().getToast(
            //'${eventNames[i + 1]} time should be greater than the ${eventNames[i]} event',
            'Please set a later time than ${eventNames[i]} time',
            Colors.red);
        return false;
      }
    }
  }
}
