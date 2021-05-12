import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> saveMap = {};
    return SimpleDialog(
      children: getDialogItems(
        onTimeSelected: (TimeOfDay timeSelected, String scheduleName) {
          var oldValue = saveMap.putIfAbsent(
            scheduleName,
            () => getTimeAsString(timeSelected),
          );
          if (oldValue != null) {
            saveMap[scheduleName] = getTimeAsString(timeSelected);
          }
        },
        onSave: () async {
          String schedules = '';
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
                    .regimentStatus !=
                RegimentStatus.Processing) {
              Navigator.pop(context, true);
            }
          }
        },
      ),
      contentPadding: EdgeInsets.all(10.0.sp),
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
            dialogItems.add(
              EventTimeTile(
                title: key,
                selectedTime: TimeOfDay(
                  hour: int.parse(timeData[0]),
                  minute: int.parse(timeData[1]),
                ),
                onTimeSelected: onTimeSelected,
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
    int hour = timeOfDay.hour;
    return '${hour > 9 ? '' : '0'}${hour}:${timeOfDay.minute > 9 ? '' : '0'}${timeOfDay.minute}';
  }
}
