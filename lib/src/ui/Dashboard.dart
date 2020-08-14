import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/DatabseUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/blocs/User/MyProfileBloc.dart';
import 'package:myfhb/src/model/Authentication/UserModel.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/ShapesPainter.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'dart:io';
import 'dart:convert';
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/src/ui/user/UserAccounts.dart';
import 'package:http/http.dart' as http;

import 'package:myfhb/constants/variable_constant.dart' as variable;

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  MyProfileBloc _myProfileBloc;
  BuildContext _myContext;
  final GlobalKey _showMaya = GlobalKey();
  final GlobalKey _provider = GlobalKey();
  final GlobalKey _records = GlobalKey();
  final GlobalKey _family = GlobalKey();
  final GlobalKey _coverImage = GlobalKey();
  UserModel saveuser = UserModel();
  File imageURIProfile;

  bool noInternet = true;
  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    /*
    var isFirstTime =
        PreferenceUtil.isKeyValid(Constants.KEY_SHOWCASE_DASHBOARD);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          Duration(milliseconds: 200),
          () => isFirstTime
              ? null
              : ShowCaseWidget.of(_myContext).startShowCase(
                  [_showMaya, _provider, _records, _family, _coverImage]));
    });
    */
    dbInitialize();

    callImportantsMethod();

    String profilebanner =
        PreferenceUtil.getStringValue(Constants.KEY_DASHBOARD_BANNER);
    if (profilebanner != null) {
      imageURIProfile = File(profilebanner);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onFinish: () {
        PreferenceUtil.saveString(
            Constants.KEY_SHOWCASE_DASHBOARD, variable.strtrue);
      },
      builder: Builder(
        builder: (context) {
          _myContext = context;
          return Scaffold(
              key: scaffold_state,
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 10,
                  unselectedFontSize: 10,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: InkWell(
                            onTap: () {
                              navigateToTelehealthScreen(0);
                            },
                            child: ImageIcon(
                              AssetImage(variable.icon_th),
                              color: Colors.black54,
                            )),
                        title: Text(
                          variable.strTelehealth,
                          style: TextStyle(color: Colors.black54),
                        )),
                    BottomNavigationBarItem(
                        icon: InkWell(
                            onTap: () {
                              moveToFamilyOrprovider(2);
                            },
                            child: ImageIcon(
                              AssetImage(variable.icon_provider),
                              color: Colors.black54,
                            )),
                        title: Text(
                          variable.strMyProvider,
                          style: TextStyle(color: Colors.black54),
                        )),
                    BottomNavigationBarItem(
                        icon: InkWell(
                          onTap: () {
                            moveToNextScreen(2);
                          },
                          child: Image.asset(
                            variable.icon_maya,
                            height: 25,
                            width: 25,
                          ),
                        ),
                        title: Text(
                          variable.strMaya,
                          style: TextStyle(color: Colors.black54),
                        )),
                    BottomNavigationBarItem(
                        icon: InkWell(
                            onTap: () {},
                            child: ImageIcon(
                              AssetImage(variable.icon_chat),
                              color: Colors.black54,
                            )),
                        title: Text(
                          variable.strChat,
                          style: TextStyle(color: Colors.black54),
                        )),
                    BottomNavigationBarItem(
                        icon: InkWell(
                            onTap: () {
                              moveToNextScreen(1);
                            },
                            child: ImageIcon(
                              AssetImage(variable.icon_records),
                              color: Colors.black54,
                            )),
                        title: Text(
                          variable.strMyRecords,
                          style: TextStyle(color: Colors.black54),
                        ))
                  ]),
              body: Center(
                  child: Container(
                      decoration: imageURIProfile != null
                          ? BoxDecoration(
                              image: DecorationImage(
                                  image: new FileImage(imageURIProfile),
                                  fit: BoxFit.cover))
                          : BoxDecoration(color: Colors.white),
                      child: Stack(children: <Widget>[
                        Container(
                          color: Colors.black.withOpacity(0.1),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          alignment: Alignment.topRight,
                          child: imageURIProfile != null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.black87,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    saveMediaDialog(context, false);
                                  },
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FHBBasicWidget.customShowCase(
                                          _coverImage,
                                          Constants.COVER_IMG_DESC,
                                          Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    Color(CommonUtil()
                                                        .getMyPrimaryColor()),
                                                    Color(CommonUtil()
                                                        .getMyGredientColor())
                                                  ])),
                                              child: IconButton(
                                                  icon: Icon(
                                                    Icons.add_a_photo,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    saveMediaDialog(
                                                        context, false);
                                                  })),
                                          Constants.COVER_IMG_TITLE),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, left: 40, right: 40),
                                        child: Text(
                                          Constants.NO_DATA_DASHBOARD,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Color(CommonUtil()
                                                  .getMyPrimaryColor()),
                                              fontSize: 13,
                                              fontFamily:
                                                  variable.font_poppins),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                        )
                      ]))));
        },
      ),
    );
  }

  saveMediaDialog(BuildContext cont, bool isProfileImage) {
    return showDialog<void>(
      context: cont,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
              title: Text(Constants.makeAChoice),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(Constants.GALLERY_TITLE),
                      onTap: () {
                        Navigator.pop(context);

                        var image =
                            ImagePicker.pickImage(source: ImageSource.gallery);
                        image.then((value) {
                          imageURIProfile = value;
                          PreferenceUtil.saveString(
                              Constants.KEY_DASHBOARD_BANNER, value.path);

                          (cont as Element).markNeedsBuild();
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    GestureDetector(
                      child: Text(Constants.CAMERA_TITLE),
                      onTap: () {
                        Navigator.pop(context);

                        var image =
                            ImagePicker.pickImage(source: ImageSource.camera);
                        image.then((value) {
                          imageURIProfile = value;
                          PreferenceUtil.saveString(
                              Constants.KEY_DASHBOARD_BANNER, value.path);

                          (cont as Element).markNeedsBuild();
                        });
                      },
                    ),
                  ],
                ),
              ));
        });
      },
    );
  }

  void moveToFamilyOrprovider(int position) {
    Navigator.pushNamed(
      context,
      router.rt_UserAccounts,
      arguments: UserAccountsArguments(selectedIndex: position),
    );

    /* Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(name: router.rt_UserAccounts),
        builder: (context) => UserAccounts(
            arguments: UserAccountsArguments(selectedIndex: position)),
      ),
    );*/
  }

  moveToNextScreen(int position) {
    if (checkPagesForEveryIndex(position)) {
      getProfileData();
      navigateToHomeScreen(position);
    } else if (noInternet == false) {
      new FHBBasicWidget()
          .showInSnackBar(Constants.STR_NO_CONNECTIVITY, scaffold_state);
    } else {
      getProfileData();

      navigateToHomeScreen(position);
    }
  }

  void navigateToHomeScreen(int position) {
    Navigator.pushNamed(
      context,
      router.rt_HomeScreen,
      arguments: HomeScreenArguments(selectedIndex: position),
    ).then((value) {});
  }

  void navigateToTelehealthScreen(int position) {
    Navigator.pushNamed(
      context,
      router.rt_TelehealthProvider,
      arguments: HomeScreenArguments(selectedIndex: position),
    ).then((value) {});
  }

  bool checkPagesForEveryIndex(int position) {
    bool condition = false;

    switch (position) {
      case 1:
        if (PreferenceUtil.getCompleteData(Constants.KEY_COMPLETE_DATA) !=
            null) {
          condition = true;
        } else {
          new FHBUtils().check().then((intenet) {
            if (intenet != null && intenet) {
              condition = true;
              noInternet = true;
            } else {
              condition = false;
              noInternet = false;
            }
          });
        }
    }

    return condition;
  }

  bool checkPagesForFamilyOrProvider(int position) {
    bool condition = false;
    getFamilyRelationAndMediaType();

    switch (position) {
      case 1:
        if (PreferenceUtil.getFamilyData(Constants.KEY_FAMILYMEMBER) != null) {
          condition = true;
        } else {
          new FHBUtils().check().then((intenet) {
            if (intenet != null && intenet) {
              condition = true;
              noInternet = true;
            } else {
              condition = false;
              noInternet = false;
            }
          });
        }
    }

    return condition;
  }

  void dbInitialize() {
    var commonConstants = new CommonConstants();
    commonConstants.getCountryMetrics();
  }

  void callImportantsMethod() async {
    getFamilyRelationAndMediaType();
    getProfileData();

    await new CommonUtil().getMedicalPreference();
  }

  void getFamilyRelationAndMediaType() async {
    await new CommonUtil().getAllCustomRoles();
    await new CommonUtil().getMediaTypes();
  }

  void getProfileData() async {
    await new CommonUtil().getUserProfileData();
  }
}
