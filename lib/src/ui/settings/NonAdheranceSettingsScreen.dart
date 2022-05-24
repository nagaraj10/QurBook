import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/src/ui/settings/NonAdheranceSettingController.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

class NonAdheranceSettingsScreen extends StatefulWidget {
  const NonAdheranceSettingsScreen({Key key}) : super(key: key);

  @override
  _NonAdheranceSettingsScreenState createState() =>
      _NonAdheranceSettingsScreenState();
}

class _NonAdheranceSettingsScreenState
    extends State<NonAdheranceSettingsScreen> {
  final controller = Get.put(NonAdheranceSettingController());

  @override
  void initState() {
    controller.getFamilyMemberList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0.0,
        title: Transform(
          // you can forcefully translate values left side using Transform
          transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
          child: Text(
            Constants.nonAdherance,
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0.sp,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: GradientAppBar(),
      ),
      body: Obx(
        () => controller.loadingData.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GetBuilder<NonAdheranceSettingController>(
                id: "newUpdate",
                builder: (val) {
                  return val.familyResponseList == null
                      ? const Center(
                          child: Text(
                            'Please re-try after some time',
                          ),
                        )
                      : val.familyResponseList.result.sharedByUsers.length != 0
                          ? showData(val.familyResponseList.result.sharedByUsers)
                          : const Center(
                              child: Text(
                                'No Patients Found',
                              ),
                            );
                },
              ),
      ),
    );
  }

  Widget showData(List<SharedByUsers> sharedByUsers) {
    return ListView.builder(
      shrinkWrap: true,
        itemCount: sharedByUsers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Text(getMemberName(sharedByUsers[index]),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),)),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        elevation: 16,
                        value:sharedByUsers[index].remainderFor,
                        onChanged: (String newValue) {
                          String id="";
                          controller.remainderForModel.result.forEach((element) {
                            if(element.name==newValue){
                              id=element.id;
                            }
                          });
                          if(sharedByUsers[index].isNewUser){
                            controller.saveNonAdherance(sharedByUsers[index].remainderMins, sharedByUsers[index].child.id, id);
                          }else{
                            controller.editNonAdherance(sharedByUsers[index].nonAdheranceId,sharedByUsers[index].remainderMins, sharedByUsers[index].child.id, id);
                          }
                        },
                        items: controller.remainderFor.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(width: 20,),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        elevation: 16,
                        value: sharedByUsers[index].remainderMins,
                        onChanged: (String newValue) {
                          if(sharedByUsers[index].isNewUser){
                            controller.saveNonAdherance(newValue.split(" ")[0], sharedByUsers[index].child.id, sharedByUsers[index].remainderForId);
                          }else{
                            controller.editNonAdherance(sharedByUsers[index].nonAdheranceId,newValue.split(" ")[0], sharedByUsers[index].child.id, sharedByUsers[index].remainderForId);
                          }
                        },
                        items: <String>['15 Mins', '30 Mins', '60 Mins']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        });
  }

  getMemberName(SharedByUsers data){
    String fulName="";
    if (data?.child?.firstName != null && data?.child?.firstName != '') {
      fulName = data?.child?.firstName;
    }
    if (data?.child?.lastName != null && data?.child?.lastName != '') {
      fulName = fulName + ' ' + data?.child?.lastName;
    }
    return fulName;
  }
}
