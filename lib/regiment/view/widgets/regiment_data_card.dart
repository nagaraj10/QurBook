import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'form_data_dialog.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/regiment/models/save_response_model.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';
import 'package:provider/provider.dart';

class RegimentDataCard extends StatelessWidget {
  final String title;
  final String time;
  final Color color;
  final IconData icon;
  final String eid;
  final List<VitalsData> vitalsData;

  const RegimentDataCard({
    @required this.title,
    @required this.time,
    @required this.color,
    @required this.icon,
    @required this.eid,
    @required this.vitalsData,
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
            FieldsResponseModel fieldsResponseModel =
                await Provider.of<RegimentViewModel>(context, listen: false)
                    .getFormData(eid: eid);
            print(fieldsResponseModel);
            if (fieldsResponseModel.isSuccess) {
              bool value = await showDialog(
                context: context,
                builder: (context) => FormDataDialog(
                  fieldsData: fieldsResponseModel.result.fields,
                  eid: eid,
                ),
              );
              if (value != null && (value ?? false)) {
                await Provider.of<RegimentViewModel>(context, listen: false)
                    .fetchRegimentData();
              }
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
                          children: [
                            Text(
                              '${title}',
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 5.0.h,
                            ),
                            Container(
                              height: 58.0.h,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                //TODO: Replace with actual count from API
                                itemCount: vitalsData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // bool needCheckbox =
                                  //     vitalsData[index].fieldType ==
                                  //         FieldType.CHECKBOX;
                                  bool isNormal = true;

                                  isNormal = (vitalsData[index].fieldType ==
                                          FieldType.NUMBER)
                                      ? int.tryParse(
                                                  vitalsData[index].value) !=
                                              null &&
                                          int.tryParse(vitalsData[index].amin) !=
                                              null &&
                                          int.tryParse(vitalsData[index].amax) !=
                                              null &&
                                          (int.tryParse(
                                                      vitalsData[index].value) <
                                                  int.tryParse(
                                                      vitalsData[index].amax) &&
                                              int.tryParse(
                                                      vitalsData[index].value) >
                                                  int.tryParse(
                                                      vitalsData[index].amin))
                                      : true;
                                  return Padding(
                                    padding: EdgeInsets.all(5.0.sp),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          //TODO: Replace with actual value from API
                                          vitalsData[index].vitalName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                            fontSize: 14.0.sp,
                                          ),
                                          maxLines: 2,
                                          softWrap: true,
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                //TODO: Replace with actual value from API
                                                '${vitalsData[index].display ?? ''}',
                                                style: TextStyle(
                                                  color: isNormal
                                                      ? color
                                                      : Colors.red,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.0.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.0.w,
                                              ),
                                              // Visibility(
                                              //   visible: needCheckbox ?? false,
                                              //   child: Container(
                                              //     width: 10.0.w,
                                              //     child: Checkbox(
                                              //       //TODO: Replace with actual value from API
                                              //       value: (int.tryParse(
                                              //                   vitalsData[index]
                                              //                           .value ??
                                              //                       '0') ??
                                              //               0) ==
                                              //           1,
                                              //       checkColor: Colors.white,
                                              //       activeColor: Colors.black,
                                              //       onChanged: (val) {},
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
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
}
