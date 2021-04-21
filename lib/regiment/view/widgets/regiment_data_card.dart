import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'form_data_dialog.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/regiment/models/save_response_model.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';
import 'package:provider/provider.dart';
import 'media_icon_widget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';

class RegimentDataCard extends StatelessWidget {
  final String title;
  final String time;
  final Color color;
  final IconData icon;
  final String eid;
  final List<VitalsData> vitalsData;
  final Otherinfo mediaData;
  final DateTime startTime;

  const RegimentDataCard({
    @required this.title,
    @required this.time,
    @required this.color,
    @required this.icon,
    @required this.eid,
    @required this.vitalsData,
    @required this.startTime,
    @required this.mediaData,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(
          left: 10.0.w,
          right: 10.0.w,
          top: 10.0.h,
        ),
        child: InkWell(
          onTap: () async {
            bool canEdit = startTime.difference(DateTime.now()).inMinutes <= 10;
            if (canEdit) {
              FieldsResponseModel fieldsResponseModel =
                  await Provider.of<RegimentViewModel>(context, listen: false)
                      .getFormData(eid: eid);
              print(fieldsResponseModel);
              if (fieldsResponseModel.isSuccess &&
                  (fieldsResponseModel.result.fields.length > 0 ||
                      mediaData.toJson().toString().contains('1'))) {
                bool value = await showDialog(
                  context: context,
                  builder: (context) => FormDataDialog(
                    fieldsData: fieldsResponseModel.result.fields,
                    eid: eid,
                    color: color,
                    mediaData: mediaData,
                  ),
                );
                if (value != null && (value ?? false)) {
                  await Provider.of<RegimentViewModel>(context, listen: false)
                      .fetchRegimentData();
                }
              } else {
                FlutterToast().getToast(
                  'No data to enter for this event',
                  Colors.red,
                );
              }
            } else {
              FlutterToast().getToast(
                'Data for future events can be entered only 10 min prior to the event time',
                Colors.red,
              );
            }
          },
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0.h,
                  ),
                  color: color,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //TODO: Change Icon to Image when data is from API
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 24.0.sp,
                      ),
                      Text(
                        //TODO: Replace with actual time
                        time,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0.sp,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: 5.0.h,
                    horizontal: 20.0.w,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: getFieldWidgets(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_circle_fill_rounded,
                              size: 30.0.sp,
                              color: color,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 3.0.w,
                child: Container(
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getFieldWidgets() {
    List<Widget> fieldWidgets = [];
    fieldWidgets.add(
      Padding(
        padding: EdgeInsets.only(
          bottom: 5.0.h,
        ),
        child: Text(
          '${title}',
          style: TextStyle(
            fontSize: 16.0.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    vitalsData?.forEach((vitalData) {
      bool isNormal = true;

      isNormal = (vitalData.fieldType == FieldType.NUMBER)
          ? int.tryParse(vitalData.value) != null &&
              int.tryParse(vitalData.amin) != null &&
              int.tryParse(vitalData.amax) != null &&
              (int.tryParse(vitalData.value) < int.tryParse(vitalData.amax) &&
                  int.tryParse(vitalData.value) > int.tryParse(vitalData.amin))
          : true;
      if ((vitalData.display ?? '').isNotEmpty) {
        fieldWidgets.add(
          Padding(
            padding: EdgeInsets.all(5.0.sp),
            child: Row(
              children: [
                Text(
                  //TODO: Replace with actual value from API
                  '${vitalData.vitalName} : ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 14.0.sp,
                  ),
                  maxLines: 2,
                  softWrap: true,
                ),
                Text(
                  //TODO: Replace with actual value from API
                  '${vitalData.display ?? ''}',
                  style: TextStyle(
                    color: isNormal ? color : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    if (mediaData != null) {
      fieldWidgets.add(
        Row(
          children: [
            Visibility(
              visible: mediaData.needVideo == '1',
              child: MediaIconWidget(
                color: color,
                icon: Icons.video_call,
              ),
            ),
            Visibility(
              visible: mediaData.needAudio == '1',
              child: MediaIconWidget(
                color: color,
                icon: Icons.audiotrack,
              ),
            ),
            Visibility(
              visible: mediaData.needPhoto == '1',
              child: MediaIconWidget(
                color: color,
                icon: Icons.photo,
              ),
            ),
            Visibility(
              visible: mediaData.needFile == '1',
              child: MediaIconWidget(
                color: color,
                icon: Icons.file_copy_rounded,
              ),
            ),
          ],
        ),
      );
    }

    return fieldWidgets;
    // ListView.builder(
    //   shrinkWrap: true,
    //   scrollDirection: Axis.horizontal,
    //   //TODO: Replace with actual count from API
    //   itemCount: vitalsData.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     // bool needCheckbox =
    //     //     vitalsData[index].fieldType ==
    //     //         FieldType.CHECKBOX;
    //
    //   },
    // );
  }
}
