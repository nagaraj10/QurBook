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
            Constants.careGiver,
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
                  val.familyResponseList == null
                      ? const Center(
                          child: Text(
                            'Please re-try after some time',
                          ),
                        )
                      : val.familyResponseList.result.sharedByUsers.length != 0
                          ? showData(
                              val.familyResponseList.result.sharedByUsers)
                          : const Center(
                              child: Text(
                                'No activities scheduled today',
                              ),
                            );
                },
              ),
      ),
    );
  }

  showData(List<SharedByUsers> sharedByUsers) {
    print(sharedByUsers.length);
    return ListView.builder(
      shrinkWrap: true,
        itemCount: sharedByUsers.length,
        itemBuilder: (context, index) {
          return Card(
            child: Row(
              children: [
                Text(sharedByUsers[index].nickName),
                Text('')
              ],
            ),
          );
        });
  }
}
