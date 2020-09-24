import 'package:flutter/material.dart';

import '../../../../common/CommonUtil.dart';
import '../../../../common/FHBBasicWidget.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../model/bot/ConversationModel.dart';
import '../../../model/user/MyProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;

class SenderLayout extends StatelessWidget {
  final Conversation c;
  MyProfile myProfile =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE_MAIN);

  SenderLayout(this.c);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
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
                  maxWidth: MediaQuery.of(context).size.width * .6,
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
        ClipOval(
            child: Container(
          height: 40,
          width: 40,
          child: FHBBasicWidget().getProfilePicWidgeUsingUrl(
              myProfile.response.data.generalInfo.profilePicThumbnailURL),
        )),
        SizedBox(width: 20),
      ],
    );
  }
}