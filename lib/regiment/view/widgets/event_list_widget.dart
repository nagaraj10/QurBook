import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/regiment/models/profile_response_model.dart';
import 'event_time_tile.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/regiment/models/save_response_model.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';

class EventListWidget extends StatelessWidget {
  EventListWidget({
    @required this.profileResultModel,
  });

  final ProfileResultModel profileResultModel;
  final _formKey = GlobalKey<FormState>();
  var eventTime = {};
  var eventController = {};
  bool isEventsAreValid = true;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> saveMap = {};
    return Form(
      key: _formKey,
      child: SimpleDialog(
        children: getDialogItems(
          onTimeSelected: (TimeOfDay timeSelected, String scheduleName,
              TextEditingController controller) {
            if (eventTime.isEmpty) {
              //add events to the list for compare
              eventTime[scheduleName] = toDouble(timeSelected);
            } else {
              isEventsAreValid = eventTimeValidation(eventTime.values.toList(),
                  eventName: scheduleName,
                  currentEventTime: toDouble(timeSelected));
              if (!isEventsAreValid) {
                var eventList = eventTime.values.toList();
                var eventControllerList = eventController.values.toList();
                bool isTimeFound = false;
                bool isEventNameFound = false;
                //int index = eventList.indexOf(toDouble(timeSelected));
                for (var data in eventList) {
                  if (data != toDouble(timeSelected) && isTimeFound) {
                    eventTime.remove(data);
                  } else if (data == toDouble(timeSelected)) {
                    isTimeFound = true;
                  }
                }

                for (var data in eventControllerList) {
                  if (data != controller && isEventNameFound) {
                    data.text = '';
                  } else if (data == controller) {
                    isEventNameFound = true;
                  }
                }
                print('-------${eventList.toString()}');
              }
            }
            var oldValue = saveMap.putIfAbsent(
              scheduleName,
              () => getTimeAsString(timeSelected),
            );
            if (oldValue != null) {
              saveMap[scheduleName] = getTimeAsString(timeSelected);
            }
          },
          onSave: () async {
            if (_formKey.currentState.validate()) {
              if (isEventsAreValid) {
                String currentLanguage = '';
                final lan = CommonUtil.getCurrentLanCode();
                if (lan != "undef") {
                  final langCode = lan.split("-").first;
                  currentLanguage = langCode;
                } else {
                  currentLanguage = 'en';
                }
                String schedules = '&Language=$currentLanguage';
                saveMap.forEach((key, value) {
                  schedules += '&$key=$value';
                });
                SaveResponseModel saveResponse =
                    await Provider.of<RegimentViewModel>(context, listen: false)
                        .saveProfile(
                  schedules: schedules,
                );
                if (saveResponse?.isSuccess ?? false) {
                  if (Provider.of<RegimentViewModel>(context, listen: false)
                          .regimentStatus ==
                      RegimentStatus.DialogOpened) {
                    Navigator.pop(context, true);
                  }
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
    );
  }

  List<Widget> getDialogItems({
    Function onTimeSelected,
    Function onSave,
  }) {
    List<Widget> dialogItems = [];

    dialogItems.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            scheduleTitle,
            style: TextStyle(
              fontSize: 16.0.sp,
              color: Color(CommonUtil().getMyPrimaryColor()),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    try {
      profileResultModel.profileData.toJson()?.forEach(
        (key, value) {
          List<String> timeData = value.split(':');
          if (timeData.length == 2) {
            eventTime[key] = toDouble(
              TimeOfDay(
                hour: int.parse(timeData[0]),
                minute: int.parse(timeData[1]),
              ),
            );
            var controllerName = TextEditingController();
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
        },
      );

      dialogItems.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150.0.w,
              child: RaisedButton(
                child: Text(
                  saveButton,
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    color: Colors.white,
                  ),
                ),
                onPressed: onSave,
                color: Color(CommonUtil().getMyPrimaryColor()),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                    5.0.sp,
                  )),
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
    int hour = timeOfDay?.hour;
    return '${hour > 9 ? '' : '0'}${hour}:${timeOfDay.minute > 9 ? '' : '0'}${timeOfDay.minute}';
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  bool eventTimeValidation(List eventList,
      {String eventName, double currentEventTime}) {
    // if (eventList.last > currentEventTime) {
    //   FlutterToast().getToast(
    //       '${eventName} time should be greater than the previous event',
    //       Colors.red);
    //   return false;
    // } else if (eventList.last == currentEventTime) {
    //   FlutterToast().getToast(
    //       '${eventName} time should\'t not be equal to the previous event',
    //       Colors.red);
    //   return false;
    // } else {
    //   eventTime[eventName] = currentEventTime;
    //   return true;
    // }
    var eventNames = eventTime.keys.toList();
    for (int i = 0; i < eventList.length; i++) {
      if (i + 1 == eventList.length) {
        return true;
      } else if (eventList[i] > eventList[i + 1]) {
        FlutterToast().getToast(
            '${eventNames[i + 1]} time should be greater than the ${eventNames[i]} event',
            Colors.red);
        return false;
      } else if (eventList[i] == eventList[i + 1]) {
        FlutterToast().getToast(
            '${eventNames[i + 1]} time should be greater than the ${eventNames[i]} event',
            Colors.red);
        return false;
      }
    }
  }
}
