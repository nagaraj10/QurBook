import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/user_plans/view_model/user_plans_view_model.dart';
import 'package:provider/provider.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage(
    this.myProfile, {
    this.textColor,
    this.circleColor,
  });

  final MyProfileModel myProfile;
  final Color textColor;
  final Color circleColor;

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        var isGoldMember =
            Provider.of<UserPlansViewModel>(context)?.isGoldMember ?? false;
        return Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) => Container(
                height: isGoldMember
                    ? constraints.maxHeight - (constraints.maxHeight / 6)
                    : constraints.maxHeight,
                width: isGoldMember
                    ? constraints.maxHeight - (constraints.maxHeight / 6)
                    : constraints.maxHeight,
                decoration: BoxDecoration(
                  gradient: isGoldMember
                      ? const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xffb07515),
                            Color(0xffedcc73),
                            Color(0xfffffdd4),
                          ],
                        )
                      : null,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                      isGoldMember ? constraints.maxHeight / 20 : 0),
                  child: ClipOval(
                    child: (myProfile?.result != null &&
                            myProfile?.result?.profilePicThumbnailUrl != '')
                        ? Image.network(
                            myProfile.result.profilePicThumbnailUrl,
                            height: 50.0.h,
                            width: 50.0.h,
                            fit: BoxFit.cover,
                            headers: {
                              HttpHeaders.authorizationHeader:
                                  PreferenceUtil.getStringValue(KEY_AUTHTOKEN)
                            },
                            errorBuilder: (context, exception, stackTrace) =>
                                Container(
                              height: 50.0.h,
                              width: 50.0.h,
                              color: circleColor ??
                                  Color(CommonUtil().getMyPrimaryColor()),
                              child: Center(
                                child: getFirstLastNameTextForProfile(
                                  myProfile,
                                  textColor: textColor,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Color(bgColorContainer),
                            height: 50.0.h,
                            width: 50.0.h,
                          ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isGoldMember,
              child: Positioned(
                bottom: -(constraints.maxHeight / 6),
                left: constraints.maxHeight / 4,
                child: Center(
                  child: Image.asset(
                    ic_gold_member,
                    height: constraints.maxHeight / 1.5,
                    width: constraints.maxHeight / 1.5,
                  ),
                ),
              ),
            ),
          ],
        );
      });
}
