import 'package:flutter/material.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';

import '../../../../common/CommonUtil.dart';
import '../../../../common/FHBBasicWidget.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../model/bot/ConversationModel.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class SenderLayout extends StatelessWidget {
  final Conversation c;
  MyProfileModel myProfile =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE);

  SenderLayout(this.c);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              c.name.toUpperCase(),
              style: Theme.of(context).textTheme.body1,
              softWrap: true,
            ),
            Card(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 1.sw * .6,
                ),
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Color(CommonUtil().getMyPrimaryColor()),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Text(
                  c.text,
                  style: Theme.of(context).textTheme.body1.apply(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            Text(
              "${c.timeStamp}",
              style:
                  Theme.of(context).textTheme.body1.apply(color: Colors.grey),
            ),
          ],
        ),
        SizedBox(
          width: 10.0.w,
        ),
        ClipOval(
            child: Container(
          height: 40.0.h,
          width: 40.0.h,
          child: FHBBasicWidget().getProfilePicWidgeUsingUrl(myProfile),
        )),
        SizedBox(width: 20.0.w),
      ],
    );
  }
}
