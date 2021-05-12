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
    @required this.formTitle,
  });

  final List<FieldModel> fieldsData;
  final String eid;
  final Color color;
  final Otherinfo mediaData;
  final String formTitle;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              widget.formTitle,
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
            ),
          ),
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
        top: 10.0.h,
        right: 5.0.w,
        left: 15.0.w,
        bottom: 10.0.h,
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
                        _showSelectionDialog(context);
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
                              audioFileName = strUploading;
                            });
                            if (imagePaths != null && imagePaths != '') {
                              saveMediaRegiment(imagePaths).then((value) {
                                if (value.isSuccess) {
                                  setState(() {
                                    audioFileName = audioPath.split('/').last;
                                  });
                                  var oldValue = saveMap.putIfAbsent(
                                    'audio',
                                    () => value.result.accessUrl,
                                  );
                                  if (oldValue != null) {
                                    saveMap['audio'] = value.result.accessUrl;
                                  }
                                } else {
                                  setState(() {
                                    audioFileName = 'Add Audio';
                                  });
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
                        if (Provider.of<RegimentViewModel>(context,
                                    listen: false)
                                .regimentStatus ==
                            RegimentStatus.DialogOpened) {
                          Navigator.pop(context, true);
                        }
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
        setState(() {
          if (fromPath == strGallery) {
            imageFileName = strUploading;
          } else if (fromPath == strFiles) {
            docFileName = strUploading;
          } else if (fromPath == strVideo) {
            videoFileName = strUploading;
          } else if (fromPath == strAudio) {
            audioFileName = strUploading;
          }
        });
        imagePaths = croppedFile.path;

        if (imagePaths != null && imagePaths != '') {
          saveMediaRegiment(imagePaths).then((value) {
            if (value.isSuccess) {
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

              var oldValue = saveMap.putIfAbsent(
                '$fromPath',
                () => value.result.accessUrl,
              );
              if (oldValue != null) {
                saveMap['$fromPath'] = value.result.accessUrl;
              }
            } else {
              setState(() {
                if (fromPath == strGallery) {
                  imageFileName = 'Add Image';
                } else if (fromPath == strFiles) {
                  docFileName = 'Add File';
                } else if (fromPath == strVideo) {
                  videoFileName = 'Add Video';
                } else if (fromPath == strAudio) {
                  audioFileName = 'Add Audio';
                }
              });
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
        imageFileName = strUploading;
        _image = File(pickedFile.path);
        imagePaths = _image.path;
      }
    });
    if (imagePaths != null && imagePaths != '') {
      saveMediaRegiment(imagePaths).then((value) {
        if (value.isSuccess) {
          setState(() {
            imageFileName = _image.path.split('/').last;
          });

          var oldValue = saveMap.putIfAbsent(
            '$fromPath',
            () => value.result.accessUrl,
          );
          if (oldValue != null) {
            saveMap['$fromPath'] = value.result.accessUrl;
          }
        } else {
          imageFileName = 'Add Image';
        }
      });
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Choose an action"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        getOpenGallery(strGallery);
                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        imgFromCamera(strGallery);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ));
        });
  }
}
