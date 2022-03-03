import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/QurHub/Models/hub_list_response.dart';
import 'package:myfhb/QurHub/Controller/add_device_controller.dart';
import 'package:myfhb/QurHub/Controller/hub_list_controller.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key key, this.hubId}) : super(key: key);
  final String hubId;
  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final controller = Get.put(AddDeviceController());
  List<SharedByUsers> _familyNames = new List();
  bool isFamilyChanged = false;
  SharedByUsers selectedUser;
  final deviceIdController = TextEditingController();
  final nickNameController = TextEditingController();
  bool isDeviceIdEmptied = false;
  var selectedId = '';
  String createdBy = '';

  @override
  void initState() {
    selectedId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    controller.getFamilyMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Add Device'),
        centerTitle: false,
        elevation: 0,
      ),
      body: Obx(
        () {
          return  controller.loadingData.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : controller.familyMembers.isSuccess
                ? Stack(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            getView(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: dropDownButton(
                                  controller.familyMembers.result.sharedByUsers),
                            ),
                          ],
                        ),
                      ),
                      getButton(),
                    ],
                  )
                : Stack(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            getView(),
                          ],
                        ),
                      ),
                      getButton(),
                    ],
                  );}
      ),
    );
  }

  Widget getButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if(deviceIdController.text.length!=0){
              if(nickNameController.text.length!=0){

                controller.saveDevice(hubId : widget.hubId,deviceId:deviceIdController.text,nickName:nickNameController.text,userId : selectedId);

              }else{
                FlutterToast().getToast('Please Enter Nick Name', Colors.red);
              }
            }else{
              FlutterToast().getToast('Please Enter Device ID', Colors.red);
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Color(CommonUtil().getMyPrimaryColor()),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Add New Device',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: qrCodeView(),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: TextFormField(
            cursorColor: Color(CommonUtil().getMyPrimaryColor()),
            controller: deviceIdController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
                color: ColorUtils.blackcolor),
            decoration: InputDecoration(
              errorText: isDeviceIdEmptied ? 'Please Enter Device ID' : null,
              hintText: 'Device ID',
              labelStyle: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.myFamilyGreyColor),
              hintStyle: TextStyle(
                fontSize: 16.0.sp,
                color: ColorUtils.myFamilyGreyColor,
                fontWeight: FontWeight.w400,
              ),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: TextFormField(
            cursorColor: Color(CommonUtil().getMyPrimaryColor()),
            controller: nickNameController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0.sp,
                color: ColorUtils.blackcolor),
            decoration: InputDecoration(
              errorText: isDeviceIdEmptied ? 'Please Enter Nick Name' : null,
              hintText: 'Nick Name',
              labelStyle: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorUtils.myFamilyGreyColor),
              hintStyle: TextStyle(
                fontSize: 16.0.sp,
                color: ColorUtils.myFamilyGreyColor,
                fontWeight: FontWeight.w400,
              ),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
            ),
          ),
        ),
      ],
    );
  }

  Widget qrCodeView(){
    return SizedBox(height: 50,width: 50,);
  }

  Widget dropDownButton(List<SharedByUsers> sharedByMeList) {
    MyProfileModel myProfile;
    String fulName = '';
    try {
      myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);
      fulName = myProfile.result != null
          ? myProfile.result.firstName?.capitalizeFirstofEach +
              ' ' +
              myProfile.result.lastName?.capitalizeFirstofEach
          : '';
    } catch (e) {}

    if (sharedByMeList == null) {
      sharedByMeList = new List();
      sharedByMeList
          .add(new SharedByUsers(id: myProfile?.result?.id, nickName: 'Self'));
    } else {
      sharedByMeList.insert(
          0, new SharedByUsers(id: myProfile?.result?.id, nickName: 'Self'));
    }
    if (_familyNames.length == 0) {
      for (int i = 0; i < sharedByMeList.length; i++) {
        _familyNames.add(sharedByMeList[i]);
      }
    }

    if (_familyNames.length > 0) {
      for (SharedByUsers sharedByUsers in _familyNames) {
        if (sharedByUsers != null) {
          if (sharedByUsers.child != null) {
            if (sharedByUsers.child.id == selectedId) {
              selectedUser = sharedByUsers;
            }
          }
        }
      }
    }

    return SizedBoxWithChild(
      height: 50,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: DropdownButton<SharedByUsers>(
          value: selectedUser,
          underline: SizedBox(),
          isExpanded: true,
          hint: Row(
            children: <Widget>[
              SizedBoxWidget(width: 20),
              Text(parameters.self,
                  style: TextStyle(
                    fontSize: 14.0.sp,
                  )),
            ],
          ),
          items: _familyNames
              .map((SharedByUsers user) => DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        SizedBoxWidget(width: 20),
                        Text(
                            user.child == null
                                ? 'Self'
                                : ((user?.child?.firstName ?? '') +
                                            ' ' +
                                            (user?.child?.lastName ?? ''))
                                        ?.capitalizeFirstofEach ??
                                    '',
                            style: TextStyle(
                              fontSize: 14.0.sp,
                            )),
                      ],
                    ),
                    value: user,
                  ))
              .toList(),
          onChanged: (SharedByUsers user) {
            isFamilyChanged = true;
            setState(() {
              // if (selectedUser != user) {
              //   clearAttachedRecords();
              // }
              selectedUser = user;
              if (user.child != null) {
                if (user.child.id != null) {
                  selectedId = user.child.id;
                }
              } else {
                selectedId = createdBy;
              }
            });
          },
        ),
      ),
    );
  }



  exitApp(){
    print('working on this');
  }
}
