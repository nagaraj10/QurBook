import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';

import '../../../../colors/fhb_colors.dart' as fhb_colors;
import '../../../../common/CommonUtil.dart';
import '../../../../common/common_circular_indicator.dart';
import '../../../../constants/fhb_constants.dart' as fhb_constants;
import '../../../../constants/variable_constant.dart';
import '../../../../src/utils/screenutils/size_extensions.dart';
import '../../../constants/router_variable.dart';
import '../../../main.dart';
import '../../../more_menu/screens/terms_and_conditon.dart';
import '../../../src/utils/colors_utils.dart';
import '../../model/voice_clone_shared_by_users.dart';
import '../../model/voice_clone_submit_request.dart';
import '../../model/voice_cloning_choose_member_arguments.dart';
import '../../services/voice_clone_members_services.dart';
import '../widgets/voice_clone_family_members_list.dart';

class VoiceCloningChooseMember extends StatefulWidget {
  final VoiceCloningChooseMemberArguments? arguments;

  const VoiceCloningChooseMember({
    required this.arguments,
  });

  @override
  State<VoiceCloningChooseMember> createState() =>
      _VoiceCloningChooseMemberState();
}

class _VoiceCloningChooseMemberState extends State<VoiceCloningChooseMember> {
  final _voiceCloneMembersServices = VoiceCloneMembersServices();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final List<VoiceCloneSharedByUsers> _listOfFamilyMembers = [];
  final _flutterToast = FlutterToast();

  bool _isLoading = true;
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
    fetchFamilyMembersList();
  }

  /// Fetch FamilyMembers list from API
  Future<void> fetchFamilyMembersList() async {
    final listFamilyMembers =
        await _voiceCloneMembersServices.getFamilyMembersListNew();
    final listOfCareGiverFamilyMembers =
        (await _voiceCloneMembersServices.getCareGiverPatientList() ?? [])
            .map((e) => e?.childId ?? '')
            .toList();

    _listOfFamilyMembers.addAll(
      listFamilyMembers.result?.sharedByUsers
              ?.where((sharedByUser) => listOfCareGiverFamilyMembers
                  .contains(sharedByUser.child?.id ?? ''))
              .map(
                (sharedByUser) => VoiceCloneSharedByUsers(
                  id: sharedByUser.id,
                  status: sharedByUser.status,
                  nickName: sharedByUser.nickName,
                  isActive: sharedByUser.isActive,
                  createdOn: sharedByUser.createdOn,
                  lastModifiedOn: sharedByUser.lastModifiedOn,
                  relationship: sharedByUser.relationship,
                  child: sharedByUser.child,
                  membershipOfferedBy: sharedByUser.membershipOfferedBy,
                  isCaregiver: sharedByUser.isCaregiver,
                  isNewUser: sharedByUser.isNewUser,
                  remainderForId: sharedByUser.remainderForId,
                  remainderFor: sharedByUser.remainderFor,
                  remainderMins: sharedByUser.remainderMins,
                  nonAdheranceId: sharedByUser.nonAdheranceId,
                  chatListItem: sharedByUser.chatListItem,
                  nickNameSelf: sharedByUser.nickNameSelf,
                  isSelected: widget.arguments?.selectedFamilyMembers
                          ?.firstWhereOrNull((element) =>
                              (element.user?.id == sharedByUser.child?.id) &&
                              (element.isActive ?? false))
                          ?.isActive ??
                      false,
                ),
              )
              .toList() ??
          [],
    );

    _hasData = _listOfFamilyMembers.isNotEmpty;
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: AppBarForVoiceCloning().getVoiceCloningAppBar(),
          centerTitle: false,
        ),
        body: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 180,
              child: _isLoading
                  ? SafeArea(
                      child: SizedBox(
                        height: 1.sh / 4.5,
                        child: Center(
                          child: SizedBox(
                            width: 30.0.h,
                            height: 30.0.h,
                            child: CommonCircularIndicator(),
                          ),
                        ),
                      ),
                    )
                  : _hasData
                      ? SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: VoiceCloneFamilyMembersList(
                              familyMembers: _listOfFamilyMembers,
                              isShowcaseExisting: false,
                              onValueSelected: (index) {
                                setState(() {
                                  _listOfFamilyMembers[index].isSelected =
                                      !_listOfFamilyMembers[index].isSelected;
                                });
                              },
                            ),
                          ),
                        )
                      : refreshIndicatorWithEmptyContainer(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: isFamilyMembersSelected()
                    ? () async {
                        final users = _listOfFamilyMembers
                            .map(
                              (familyMember) => VoiceCloneUserRequest(
                                id: familyMember.child?.id,
                                isActive: familyMember.isSelected,
                              ),
                            )
                            .toList();
                        final voiceClone = VoiceCloneBaseRequest(
                          id: widget.arguments?.voiceCloneId,
                        );
                        final request = VoiceCloneRequest(
                            user: users, voiceClone: voiceClone);
                        final response = await _voiceCloneMembersServices
                            .submitVoiceCloneWithFamilyMembers(request);
                        _flutterToast.getToast(
                            response.message ?? '', Colors.green);

                        Navigator.popUntil(context, (route) {
                          var shouldPop = false;
                          if ([rt_notification_main, rt_more_menu]
                              .contains(route.settings.name)) {
                            shouldPop = true;
                          }
                          return shouldPop;
                        });
                      }
                    : null,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isFamilyMembersSelected()
                        ? mAppThemeProvider.primaryColor
                        : ColorUtils.greycolor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 30.sp,
                      right: 30.sp,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      strSubmit,
                      style: TextStyle(
                        color: isFamilyMembersSelected()
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  bool isFamilyMembersSelected() => _listOfFamilyMembers
      .where((element) => element.isSelected == true)
      .isNotEmpty;

  Widget refreshIndicatorWithEmptyContainer() => RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await _refreshIndicatorKey.currentState?.show();
          setState(() {});
          await _refreshIndicatorKey.currentState?.show(atTop: false);
        },
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: const Color(fhb_colors.bgColorContainer),
              child: const Center(
                child: Text(
                  fhb_constants.NO_DATA_FAMIY,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
}
