import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_user_info/models/add_family_user_info_arguments.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_family/models/Sharedbyme.dart';
import 'package:myfhb/my_family/screens/MyFamily.dart';
import 'package:myfhb/my_providers/screens/my_provider.dart';
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';

import 'MyProfilePage.dart';

class UserAccounts extends StatefulWidget {
  UserAccountsArguments arguments;

  UserAccounts({this.arguments});

  @override
  _UserAccountsState createState() => _UserAccountsState();
}

class _UserAccountsState extends State<UserAccounts>
    with SingleTickerProviderStateMixin {
  double sliverBarHeight = 220;
  TabController _sliverTabController;
  int selectedTab = 0;
  bool _isEditable = false;
  File imageURIProfile, profileImage;

  @override
  void initState() {
    super.initState();
    PreferenceUtil.init();
    _sliverTabController = TabController(
        vsync: this, length: 3, initialIndex: widget.arguments.selectedIndex);
    _sliverTabController.addListener(_handleSelected);
  }

  void _handleSelected() {
    this.setState(() {
      selectedTab = _sliverTabController.index;
      if (selectedTab != 0) {
        sliverBarHeight = 50;
      } else {
        sliverBarHeight = 220;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MyProfile myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE_MAIN);

    Sharedbyme sharedbyme = new CommonUtil().getProfileDetails();

    String profilebanner =
        PreferenceUtil.getStringValue(Constants.KEY_PROFILE_BANNER);
    if (profilebanner != null) {
      imageURIProfile = File(profilebanner);
    }

    String profileImageFile =
        PreferenceUtil.getStringValue(Constants.KEY_PROFILE_IMAGE);
    if (profileImageFile != null) {
      profileImage = File(profileImageFile);
    }

    return Scaffold(
      backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
              expandedHeight: sliverBarHeight,
              floating: false,
              pinned: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: <Widget>[
                selectedTab == 0
                    ? IconButton(
                        icon: _isEditable
                            ? Visibility(
                                visible: false, child: Icon(Icons.save))
                            : Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            if (_isEditable) {
                              _isEditable = false;
                            } else {
                              _isEditable = true;
                              //sliverBarHeight = 50;

                              Navigator.pushNamed(
                                      context, router.rt_AddFamilyUserInfo,
                                      arguments: AddFamilyUserInfoArguments(
                                          sharedbyme: sharedbyme,
                                          fromClass:
                                              CommonConstants.user_update))
                                  .then((value) {
                                setState(() {
                                  _isEditable = false;
                                });
                              });
                            }
                            sliverBarHeight = 220;
                          });
                        })
                    : Container(
                        height: 0,
                        width: 0,
                      )
              ],
              flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 40),
                  centerTitle: false,
                  title: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 30,
                          width: 30,
                          child: ClipOval(
                            child: profileImage != null
                                ? Image.file(profileImage,
                                    fit: BoxFit.cover, width: 100, height: 100)
                                : FHBBasicWidget().getProfilePicWidgeUsingUrl(
                                    myProfile.response.data.generalInfo
                                        .profilePicThumbnailURL),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          myProfile.response.data.generalInfo.qualifiedFullName !=
                              null
                              ? toBeginningOfSentenceCase(myProfile
                              .response
                              .data
                              .generalInfo
                              .qualifiedFullName
                              .firstName ??
                              '') +
                              ' ' +
                              toBeginningOfSentenceCase(myProfile.response.data
                                  .generalInfo.qualifiedFullName.lastName ??
                                  '')
                              : '',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.fade,
                        )
                      ],
                    ),
                  ),
                  background: imageURIProfile != null
                      ? Image.file(imageURIProfile,
                          fit: BoxFit.cover, width: 100, height: 100)
                      : Container(
                          color: Colors.black.withOpacity(0.2),
                        )),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _sliverTabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2,
                  tabs: [
                    Tab(text: variable.strMyInfo),
                    Tab(text: variable.strMyFamily),
                    Tab(text: variable.strMyProvider),
                  ],
                ),
              ),
              pinned: true,
              floating: false,
            ),
          ];
        },
        body: Container(
          child: TabBarView(
            controller: _sliverTabController,
            children: <Widget>[MyProfilePage(), MyFamily(), MyProvider()],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
