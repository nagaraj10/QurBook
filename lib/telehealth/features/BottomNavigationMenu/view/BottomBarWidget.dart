import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/chat/view/BadgeIcon.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class BottomBarWidget extends StatelessWidget {
  String name;
  String icon;
  int pageIndex;
  int selectedPageIndex;

  BottomBarWidget(
      {this.name, this.icon, this.pageIndex, this.selectedPageIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            name == variable.strMaya
                ? Image.asset(
                    PreferenceUtil.getStringValue(Constants.keyMayaAsset) !=
                            null
                        ? PreferenceUtil.getStringValue(
                                Constants.keyMayaAsset) +
                            variable.strExtImg
                        : variable.icon_mayaMain,
                    height: 25.0.h,
                    width: 25.0.h,
                  )
                : name == 'Chats'
                    ? getChatIcon(icon)
                    : ImageIcon(
                        AssetImage(icon),
                        size: 20.0.sp,
                        color: selectedPageIndex == pageIndex
                            ? Colors.white
                            : Colors.black,
                      ),
            selectedPageIndex == pageIndex
                ? Container(
                    height: 0.0.h,
                    width: 0.0.h,
                  )
                : Text(
                    name,
                    style: TextStyle(
                      fontSize: 10.0.sp,
                    ),
                  )
          ],
        ));
  }

  Widget getChatIcon(String icon) {
    int count = 0;
    String targetID = PreferenceUtil.getStringValue(KEY_USERID);
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(STR_CHAT_LIST)
            .document(targetID)
            .collection(STR_USER_LIST)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            count = 0;
            snapshot.data.documents.toList().forEach((element) {
              if (element.data[STR_IS_READ_COUNT] != null &&
                  element.data[STR_IS_READ_COUNT] != '') {
                count = count + element.data[STR_IS_READ_COUNT];
              }
            });
            return BadgeIcon(
                icon: GestureDetector(
                  child: ImageIcon(
                    AssetImage(icon),
                    size: 20.0.sp,
                    color: selectedPageIndex == pageIndex
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                badgeColor: ColorUtils.countColor,
                badgeCount: count);
          } else {
            return BadgeIcon(
                icon: GestureDetector(
                  child: ImageIcon(
                    AssetImage(icon),
                    size: 20.0.sp,
                    color: selectedPageIndex == pageIndex
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                badgeCount: 0);
          }
        });
  }
}
