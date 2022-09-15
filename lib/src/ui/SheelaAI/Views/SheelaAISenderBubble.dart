import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/CommonUtil.dart';
import '../../../../common/FHBBasicWidget.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../utils/screenutils/size_extensions.dart';
import '../Controller/SheelaAIController.dart';
import '../Models/SheelaResponse.dart';
import 'CommonUitls.dart';

class SheelaAISenderBubble extends StatelessWidget {
  final SheelaResponse chat;
  SheelaAIController controller = Get.find();
  SheelaAISenderBubble(
    this.chat,
  );

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
              if (!PreferenceUtil.getIfQurhomeisAcive())
                Text(
                  controller.userName,
                  style: PreferenceUtil.getIfQurhomeisAcive()
                      ? Theme.of(context).textTheme.bodyText2.apply(
                            color: Colors.black,
                          )
                      : Theme.of(context).textTheme.bodyText2,
                  softWrap: true,
                ),
              Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: chatBubbleBorderRadiusFor(
                    true,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: PreferenceUtil.getIfQurhomeisAcive()
                        ? Colors.white
                        : Color(CommonUtil().getMyPrimaryColor()),
                    borderRadius: chatBubbleBorderRadiusFor(true),
                  ),
                  child: Text(
                    chat.text,
                    style: Theme.of(context).textTheme.bodyText2.apply(
                          fontSizeFactor: CommonUtil().isTablet ? 1.6 : 1.0,
                          color: PreferenceUtil.getIfQurhomeisAcive()
                              ? Colors.black
                              : Colors.white,
                        ),
                  ),
                ),
              ),
              if (!PreferenceUtil.getIfQurhomeisAcive())
                Text(
                  chat.timeStamp,
                  style: Theme.of(context).textTheme.bodyText2.apply(
                        color: Colors.grey,
                      ),
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
            child: FHBBasicWidget().getProfilePicWidgeUsingUrl(
              controller.profile,
            ),
          ),
        ),
        SizedBox(
          width: 20.0.w,
        ),
      ],
    );
  }
}
