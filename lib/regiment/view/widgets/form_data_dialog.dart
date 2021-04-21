import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'form_field_widget.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';
import 'package:myfhb/regiment/models/save_response_model.dart';
import 'package:provider/provider.dart';
import 'media_icon_widget.dart';

class FormDataDialog extends StatelessWidget {
  FormDataDialog({
    @required this.fieldsData,
    @required this.eid,
    @required this.color,
    @required this.mediaData,
  });

  final List<FieldModel> fieldsData;
  final String eid;
  final Color color;
  final Otherinfo mediaData;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> saveMap = {};
    return SimpleDialog(
      children: [
        Container(
          width: 0.75.sw,
          padding: EdgeInsets.all(
            10.0.sp,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              bottom: 10.0.h,
            ),
            itemCount: fieldsData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: 10.0.h,
                ),
                child: FormFieldWidget(
                  fieldData: fieldsData[index],
                  updateValue: (
                    FieldModel updatedFieldData, {
                    bool isAdd,
                    String title,
                  }) {
                    if (isAdd == null || isAdd) {
                      isAdd = isAdd ?? false;
                      var oldValue = saveMap.putIfAbsent(
                        isAdd ? 'pf_${title}' : 'pf_${updatedFieldData.title}',
                        () => updatedFieldData.value,
                      );
                      if (oldValue != null) {
                        saveMap[isAdd
                                ? 'pf_${title}'
                                : 'pf_${updatedFieldData.title}'] =
                            updatedFieldData.value;
                      }
                    } else {
                      saveMap.remove('pf_${title}');
                    }
                  },
                ),
              );
            },
          ),
        ),
        Container(
          width: 0.75.sw,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: mediaData.needPhoto == '1',
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.camera_alt,
                  padding: 10.0.sp,
                ),
              ),
              Visibility(
                visible: mediaData.needAudio == '1',
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.mic,
                  padding: 10.0.sp,
                ),
              ),
              Visibility(
                visible: mediaData.needVideo == '1',
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.videocam,
                  padding: 10.0.sp,
                ),
              ),
              Visibility(
                visible: mediaData.needFile == '1',
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.attach_file,
                  padding: 10.0.sp,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 0.75.sw,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text(
                  saveButton,
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  String events = '';
                  print(saveMap.toString());
                  saveMap.forEach((key, value) {
                    events += '&$key=$value';
                  });
                  print(events);
                  SaveResponseModel saveResponse =
                      await Provider.of<RegimentViewModel>(context,
                              listen: false)
                          .saveFormData(
                    eid: eid,
                    events: events,
                  );
                  if (saveResponse?.isSuccess ?? false) {
                    Navigator.pop(context, true);
                  }
                },
                color: Color(CommonUtil().getMyPrimaryColor()),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(
                    5.0.sp,
                  )),
                ),
              ),
            ],
          ),
        ),
      ],
      contentPadding: EdgeInsets.all(10.0.sp),
    );
  }
}
