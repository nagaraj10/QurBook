import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';

import '../../../colors/fhb_colors.dart' as fhb_colors;
import '../../../common/CommonUtil.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../constants/fhb_constants.dart' as fhb_constants;
import '../../../constants/fhb_parameters.dart';
import '../../../constants/variable_constant.dart' as variable;
import '../../../main.dart';
import '../../../my_family/models/FamilyMembersRes.dart';
import '../../../src/utils/colors_utils.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../model/voice_clone_shared_by_users.dart';

class VoiceCloneFamilyMembersList extends StatefulWidget {
  final List<VoiceCloneSharedByUsers> familyMembers;
  final bool isShowcaseExisting;
  final void Function(int) onValueSelected;
  final bool isScrollParent;

  const VoiceCloneFamilyMembersList({
    required this.familyMembers,
    required this.onValueSelected,
    this.isShowcaseExisting = false,
    this.isScrollParent = false,
  });

  @override
  State<VoiceCloneFamilyMembersList> createState() =>
      _VoiceCloneFamilyMembersListState();
}

class _VoiceCloneFamilyMembersListState
    extends State<VoiceCloneFamilyMembersList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                child: Text(
                  widget.isShowcaseExisting
                      ? variable.strVoiceCloningExistingMembersHeader
                      : variable.strVoiceCloningAddMembersHeader,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: mobileFontTitle,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            widget.isScrollParent
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: widget.familyMembers.length,
                    itemBuilder: (contextList, index) =>
                        _getVoiceCloneFamilyMemberWidget(
                      contextList,
                      widget.familyMembers[index],
                      index,
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: widget.familyMembers.length,
                      itemBuilder: (contextList, index) =>
                          _getVoiceCloneFamilyMemberWidget(
                        contextList,
                        widget.familyMembers[index],
                        index,
                      ),
                    ),
                  ),
          ],
        ),
      );

  Widget _getVoiceCloneFamilyMemberWidget(
      BuildContext context, VoiceCloneSharedByUsers familyMember, int index,
      {FamilyMemberResult? userCollection}) {
    String? fulName = '';

    if (familyMember.child?.firstName != null &&
        familyMember.child?.firstName != '') {
      fulName = familyMember.child?.firstName;
    }
    if (familyMember.child?.lastName != null &&
        familyMember.child?.lastName != '') {
      fulName = '${fulName!} ${familyMember.child?.lastName!}';
    }

    final userProfileImageSize = 40.0.h;
    final userProfileFontSize = 15.0.sp;

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFe3e2e2),
            blurRadius: 16, // has the effect of softening the shadow
            spreadRadius: 2,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: (familyMember.child?.profilePicThumbnailUrl ?? '')
                        .isEmpty
                    ? Container(
                        width: userProfileImageSize,
                        height: userProfileImageSize,
                        color: const Color(fhb_colors.bgColorContainer),
                        child: Center(
                          child: Text(
                            familyMember.child != null
                                ? familyMember.child!.firstName![0]
                                    .toUpperCase()
                                : '',
                            style: TextStyle(
                              fontSize: userProfileFontSize,
                              color: mAppThemeProvider.primaryColor,
                            ),
                          ),
                        ),
                      )
                    : Image.network(
                        familyMember.child?.profilePicThumbnailUrl ?? '',
                        fit: BoxFit.cover,
                        width: userProfileImageSize,
                        height: userProfileImageSize,
                        headers: {
                          HttpHeaders.authorizationHeader:
                              PreferenceUtil.getStringValue(
                                  fhb_constants.KEY_AUTHTOKEN)!,
                        },
                        errorBuilder: (context, exception, stackTrace) =>
                            Container(
                          height: userProfileImageSize,
                          width: userProfileImageSize,
                          color: mAppThemeProvider.primaryColor,
                          child: Center(
                            child: Text(
                              familyMember.child?.firstName != null &&
                                      familyMember.child!.lastName != null
                                  ? familyMember.child!.firstName![0]
                                          .toUpperCase() +
                                      ((familyMember.child?.lastName?.length ??
                                                  0) >
                                              0
                                          ? familyMember.child!.lastName![0]
                                              .toUpperCase()
                                          : '')
                                  : familyMember.child!.firstName != null
                                      ? familyMember.child!.firstName![0]
                                          .toUpperCase()
                                      : '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: userProfileFontSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
          SizedBox(
            width: 20.0.w,
          ),
          Expanded(
            // flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  familyMember.child?.firstName != null
                      ? CommonUtil().titleCase(fulName)
                      : '',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0.sp,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 1.0.h,
                ),
                Text(
                  (familyMember.child?.isVirtualUser != null &&
                          (familyMember.child?.isVirtualUser ?? false))
                      /*? data?.child?.isVirtualUser
                                */
                      ? userCollection?.virtualUserParent?.phoneNumber ?? ''
                      : ((familyMember.child?.userContactCollection3 != null &&
                              (familyMember.child?.userContactCollection3
                                      ?.isNotEmpty ??
                                  false))
                          ? familyMember
                              .child?.userContactCollection3![0].phoneNumber!
                          : '')!,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: ColorUtils.greycolor1,
                    fontSize: 16.0.sp,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 1.0.h,
                ),
                Text(
                  familyMember.relationship != null
                      ? familyMember.relationship?.name ?? ''
                      : '',
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0.sp,
                    color: mAppThemeProvider.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !widget.isShowcaseExisting,
            child: InkWell(
              onTap: () {
                widget.onValueSelected(index);
              },
              child: familyMember.isSelected
                  ? getCheckedImage()
                  : ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.saturation,
                      ),
                      child: getCheckedImage(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getCheckedImage() => Image.asset(
        VOICE_CLONE_USER_SELECTED,
        width: 24.0.h,
        height: 24.0.h,
      );
}
