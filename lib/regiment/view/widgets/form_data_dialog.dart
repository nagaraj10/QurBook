import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/regiment/view_model/AddRegimentModel.dart';
import 'package:myfhb/regiment/view_model/pickImageController.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/ui/audio/AudioScreenArguments.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
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
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class FormDataDialog extends StatefulWidget {
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
  State<StatefulWidget> createState() => FormDataDialogState();
}

class FormDataDialogState extends State<FormDataDialog> {
  List<FieldModel> fieldsData;
  String eid;
  Color color;
  Otherinfo mediaData;

  String videoFileName = 'Add Video';
  String audioFileName = 'Add Audio';
  String imageFileName = 'Add Image';
  String docFileName = 'Add File';

  String imagePaths = '';

  ApiBaseHelper _helper = ApiBaseHelper();
  Map<String, dynamic> saveMap = {};

  @override
  void initState() {
    super.initState();

    fieldsData = widget.fieldsData;
    eid = widget.eid;
    color = widget.color;
    mediaData = widget.mediaData;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              Icons.close,
              size: 24.0.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      titlePadding: EdgeInsets.only(
        top: 5.0.h,
        right: 5.0.w,
      ),
      content: Container(
        width: 0.75.sw,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              width: 0.75.sw,
              padding: EdgeInsets.only(
                bottom: 10.0.h,
                left: 10.0.w,
                right: 10.0.w,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  bottom: 10.0.h,
                  top: 0.0.h,
                ),
                physics: NeverScrollableScrollPhysics(),
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
                            isAdd
                                ? 'pf_${title}'
                                : 'pf_${updatedFieldData.title}',
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
                    child: InkWell(
                      onTap: () {
                        //getOpenGallery(strGallery);
                        imgFromCamera(strGallery);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MediaIconWidget(
                            color: color,
                            icon: Icons.camera_alt,
                            padding: 10.0.sp,
                          ),
                          SizedBox(
                            width: 250.0.w,
                            child: Text(
                              imageFileName,
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: mediaData.needAudio == '1',
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => AudioRecordScreen(
                              arguments: AudioScreenArguments(
                            fromVoice: false,
                          )),
                        ))
                            .then((results) {
                          String audioPath = results[Constants.keyAudioFile];
                          if (audioPath != null && audioPath != '') {
                            imagePaths = audioPath;
                            setState(() {
                              audioFileName = audioPath.split('/').last;
                            });
                            if (imagePaths != null && imagePaths != '') {
                              saveMediaRegiment(imagePaths).then((value) {
                                if (value.isSuccess) {
                                  print('url:  ' + value.result.accessUrl);
                                  var oldValue = saveMap.putIfAbsent(
                                    'pf_audio',
                                    () => value.result.accessUrl,
                                  );
                                  if (oldValue != null) {
                                    saveMap['pf_audio'] =
                                        value.result.accessUrl;
                                  }
                                }
                              });
                            }
                          }
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MediaIconWidget(
                            color: color,
                            icon: Icons.mic,
                            padding: 10.0.sp,
                          ),
                          SizedBox(
                            width: 250.0.w,
                            child: Text(
                              audioFileName,
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: mediaData.needVideo == '1',
                    child: InkWell(
                      onTap: () {
                        getOpenGallery(strVideo);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MediaIconWidget(
                            color: color,
                            icon: Icons.videocam,
                            padding: 10.0.sp,
                          ),
                          SizedBox(
                            width: 250.0.w,
                            child: Text(
                              videoFileName,
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: mediaData.needFile == '1',
                    child: InkWell(
                      onTap: () {
                        getOpenGallery(strFiles);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MediaIconWidget(
                            color: color,
                            icon: Icons.attach_file,
                            padding: 10.0.sp,
                          ),
                          SizedBox(
                            width: 250.0.w,
                            child: Text(
                              docFileName,
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
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
        ),
      ),
      contentPadding: EdgeInsets.only(
        top: 0.0.h,
        left: 10.0.w,
        right: 10.0.w,
        bottom: 10.0.w,
      ),
    );
  }

  Future<AddMediaRegimentModel> saveMediaRegiment(String imagePaths) async {
    String patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    var response = await _helper.saveRegimentMedia(
        qr_save_regi_media, imagePaths, patientId);
    return AddMediaRegimentModel.fromJson(response);
  }

  void getOpenGallery(String fromPath) {
    PickImageController.instance
        .cropImageFromFile(fromPath)
        .then((croppedFile) {
      if (croppedFile != null) {
        File file = new File(croppedFile.path);
        setState(() {
          if (fromPath == strGallery) {
            imageFileName = file.path.split('/').last;
          } else if (fromPath == strFiles) {
            docFileName = file.path.split('/').last;
          } else if (fromPath == strVideo) {
            videoFileName = file.path.split('/').last;
          } else if (fromPath == strAudio) {
            audioFileName = file.path.split('/').last;
          }
        });
        imagePaths = croppedFile.path;

        if (imagePaths != null && imagePaths != '') {
          saveMediaRegiment(imagePaths).then((value) {
            if (value.isSuccess) {
              var oldValue = saveMap.putIfAbsent(
                'pf_$fromPath',
                () => value.result.accessUrl,
              );
              if (oldValue != null) {
                saveMap['pf_$fromPath'] = value.result.accessUrl;
              }
            }
          });
        }
      }
    });
  }

  imgFromCamera(String fromPath) async {
    File _image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageFileName = _image.path.split('/').last;
        imagePaths = _image.path;
      }
    });
    if (imagePaths != null && imagePaths != '') {
      saveMediaRegiment(imagePaths).then((value) {
        if (value.isSuccess) {
          var oldValue = saveMap.putIfAbsent(
            'pf_$fromPath',
                () => value.result.accessUrl,
          );
          if (oldValue != null) {
            saveMap['pf_$fromPath'] =
                value.result.accessUrl;
          }
        }
      });
    }
  }
}
