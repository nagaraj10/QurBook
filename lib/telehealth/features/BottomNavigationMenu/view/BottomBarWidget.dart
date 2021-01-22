import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';

import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/chat/view/BadgeIcon.dart';

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
            name == 'Sheela'
                ? Image.asset(
                    icon,
                    height: 25,
                    width: 25,
                  )
                : name == 'Chats'?getChatIcon(icon):ImageIcon(
                    AssetImage(icon),
                    size: 20,
                    color: selectedPageIndex == pageIndex
                        ? Colors.white
                        : Colors.black,
                  ),
            selectedPageIndex == pageIndex
                ? Container(
                    height: 0,
                    width: 0,
                  )
                : Text(
                    name,
                    style: TextStyle(fontSize: 10),
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
              count = count + element.data[STR_IS_READ_COUNT];
            });
            return BadgeIcon(
                icon: GestureDetector(
                  child: ImageIcon(
                    AssetImage(icon),
                    size: 20,
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
                    size: 20,
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
