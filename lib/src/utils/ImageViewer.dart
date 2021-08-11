import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/regiment/view_model/AddRegimentModel.dart';
import 'package:myfhb/regiment/view_model/pickImageController.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:get/get.dart';
import '../../../constants/fhb_constants.dart' as Constants;

class ImageViewer extends StatefulWidget {
  String imageURL;
  String eid;

  ImageViewer(this.imageURL, this.eid);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool enabledEdit = false;
  final ApiBaseHelper _helper = ApiBaseHelper();
  FlutterToast toast = FlutterToast();
  String imagePath;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          flexibleSpace: GradientAppBar(),
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Image',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 24.0.sp,
              ),
            ),
          ),
          leading: GestureDetector(
            onTap: () => onBackPressed(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white, // add custom icons also
              size: 24.0.sp,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                if (enabledEdit) {
                  updateImage(context);
                }
                setState(() {
                  enabledEdit = !enabledEdit;
                });
              },
              child: Image.asset(
                enabledEdit ? icon_save_image : icon_edit_image,
                width: 24.0.sp,
                height: 24.0.sp,
              ),
            ),
            SizedBox(
              width: 16,
            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              enabledEdit
                  ? Container(
                      height: 100,
                      padding: EdgeInsets.all(
                        8,
                      ),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getIcons(
                            context,
                            IconType.Delete,
                          ),
                          getIcons(
                            context,
                            IconType.Gallery,
                          ),
                          getIcons(
                            context,
                            IconType.Camera,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 100,
                    ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.imageURL,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }

  void getOpenGallery() {
    PickImageController.instance.cropImageFromFile('photo').then((croppedFile) {
      if (croppedFile != null) {
        LoaderClass.showLoadingDialog(Get.context, canDismiss: false);
        setState(() {});
        var imagePaths = croppedFile.path;

        if ((imagePaths ?? '').isNotEmpty) {
          saveMediaRegiment(imagePaths).then((value) {
            LoaderClass.hideLoadingDialog(Get.context);
            if (value.isSuccess) {
              setState(() {
                imagePath = value.result.accessUrl;

                widget.imageURL = value.result.accessUrl;
              });
            } else {
              setState(() {
                imagePath = null;
              });
              toast.getToast(
                'Failed to upload the image, retry again',
                Colors.red,
              );
            }
          });
        }
      }
    });
  }

  void imgFromCamera() async {
    File _image;
    var picker = ImagePicker();
    var pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );
    LoaderClass.showLoadingDialog(Get.context, canDismiss: false);
    setState(() {});
    _image = File(pickedFile.path);

    if ((_image.path ?? '').isNotEmpty) {
      await saveMediaRegiment(_image.path).then((value) {
        LoaderClass.hideLoadingDialog(Get.context);

        if (value.isSuccess) {
          setState(() {
            imagePath = value.result.accessUrl;
            widget.imageURL = value.result.accessUrl;
          });
        } else {
          setState(() {
            imagePath = null;
          });
          toast.getToast(
            'Failed to upload the image, retry again',
            Colors.red,
          );
        }
      });
    }
  }

  Future<AddMediaRegimentModel> saveMediaRegiment(String imagePaths) async {
    var patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    final response = await _helper.saveRegimentMedia(
        qr_save_regi_media, imagePaths, patientId);
    return AddMediaRegimentModel.fromJson(response);
  }

  Widget getIcons(BuildContext context, IconType type) {
    return InkWell(
      onTap: () {
        switch (type) {
          case IconType.Camera:
            imgFromCamera();
            break;
          case IconType.Delete:
            onDeleteTapped(context);
            break;
          case IconType.Gallery:
            getOpenGallery();
            break;
          default:
            imgFromCamera();
            break;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 4,
                decoration: BoxDecoration(
                  color: Color(
                    CommonUtil().getMyPrimaryColor(),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Image.asset(
                getIconImage(type),
                color: Colors.white,
                height: 24.0.sp,
                width: 24.0.sp,
              )
            ],
          ),
          Text(
            getText(type),
            style: TextStyle(
              fontSize: 12,
              color: Color(
                CommonUtil().getMyPrimaryColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getIconImage(IconType type) {
    switch (type) {
      case IconType.Camera:
        return icon_camera_image;
        break;
      case IconType.Delete:
        return icon_delete_image;
        break;
      case IconType.Gallery:
        return icon_photo_image;
        break;
      default:
        return icon_camera_image;
        break;
    }
  }

  String getText(IconType type) {
    switch (type) {
      case IconType.Camera:
        return "Camera";
        break;
      case IconType.Delete:
        return "Remove photo";
        break;
      case IconType.Gallery:
        return "Gallery";
        break;
      default:
        return "Camera";
        break;
    }
  }

  onBackPressed(BuildContext context) {
    Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData();
    Navigator.pop(context);
  }

  updateImage(BuildContext context) async {
    if (imagePath != null) {
      final saveResponse =
          await Provider.of<RegimentViewModel>(context, listen: false)
              .updatePhoto(eid: widget.eid, url: imagePath);
      if (saveResponse.isSuccess) {
        toast.getToast(
          'Image updated successfully',
          Colors.green,
        );
        imagePath = null;
      } else {
        toast.getToast(
          'Failed to update the image, retry again',
          Colors.red,
        );
      }
    }
  }

  onDeleteTapped(BuildContext context) async {
    final saveResponse =
        await Provider.of<RegimentViewModel>(context, listen: false)
            .deletMedia(eid: widget.eid);
    onBackPressed(context);
  }
}

enum IconType {
  Delete,
  Gallery,
  Camera,
}
