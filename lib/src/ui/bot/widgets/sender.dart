import 'package:flutter/material.dart';

import '../../../../common/CommonUtil.dart';
import '../../../../common/FHBBasicWidget.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../constants/fhb_constants.dart' as constants;
import '../../../model/bot/ConversationModel.dart';
import '../../../model/user/MyProfileModel.dart';
import '../../../utils/screenutils/size_extensions.dart';

class SenderLayout extends StatelessWidget {
  final Conversation c;
  MyProfileModel myProfile =
      PreferenceUtil.getProfileData(constants.KEY_PROFILE);

  SenderLayout(this.c);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: PreferenceUtil.getIfQurhomeisAcive()
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        SizedBox(width: 20.0.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PreferenceUtil.getIfQurhomeisAcive()
                  ? Container()
                  : Text(
                      c.name.toUpperCase(),
                      style: PreferenceUtil.getIfQurhomeisAcive()
                          ? Theme.of(context).textTheme.body1.apply(
                                color: Colors.black,
                              )
                          : Theme.of(context).textTheme.body1,
                      softWrap: true,
                    ),
              Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: PreferenceUtil.getIfQurhomeisAcive()
                        ? Radius.zero
                        : Radius.circular(25),
                    topRight: PreferenceUtil.getIfQurhomeisAcive()
                        ? Radius.circular(25)
                        : Radius.zero,
                  ),
                ),
                child: Container(
                  // constraints: BoxConstraints(
                  //   maxWidth: 1.sw * .6,
                  // ),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: PreferenceUtil.getIfQurhomeisAcive()
                        ? Colors.white
                        : Color(CommonUtil().getMyPrimaryColor()),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      topRight: PreferenceUtil.getIfQurhomeisAcive()
                          ? Radius.circular(25)
                          : Radius.zero,
                      bottomRight: PreferenceUtil.getIfQurhomeisAcive()
                          ? Radius.zero
                          : Radius.circular(25),
                    ),
                  ),
                  child: Text(
                    c.text,
                    style: Theme.of(context).textTheme.body1.apply(
                          color: PreferenceUtil.getIfQurhomeisAcive()
                              ? Colors.black
                              : Colors.white,
                        ),
                  ),
                ),
              ),
              PreferenceUtil.getIfQurhomeisAcive()
                  ? Container()
                  : c.timeStamp==null||c.timeStamp=="null"?Container():Text(
                      "${c.timeStamp}",
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .apply(color: Colors.grey),
                    ),
            ],
          ),
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
