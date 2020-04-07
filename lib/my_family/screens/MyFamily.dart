import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/src/blocs/Family/FamilyListBloc.dart';
import 'package:myfhb/src/model/Family/FamilyMembersResponse.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/utils/colors_utils.dart';

class MyFamily extends StatefulWidget {
  @override
  _MyFamilyState createState() => _MyFamilyState();
}

class _MyFamilyState extends State<MyFamily> {
  FamilyListBloc _familyListBloc;
  final searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _familyListBloc = new FamilyListBloc();
    _familyListBloc.getFamilyMembersList();
  }

  @override
  Widget build(BuildContext context) {
    /*  return Scaffold(
      backgroundColor: const Color(0xFFf7f6f5),
      /*  appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: GradientAppBar(),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('My Family'),
          centerTitle: false,
          /*  actions: <Widget>[
              new RawMaterialButton(
                constraints: BoxConstraints(minHeight: 36, minWidth: 36),
                onPressed: () {},
                child: new Icon(
                  Icons.add,
                  //color: Colors.blue,
                  size: 22.0,
                ),
                shape: new CircleBorder(side: BorderSide(color: Colors.white)),
                //elevation: 2.0,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.all(15.0),
              ),
            ], */
          //),
        ),
      ),
      */
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: Container(
        //color: Colors.grey[100],
        child: getAllFamilyMembers(),
      ),
    );
     */
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              saveMediaDialog(context);
            }),
        body: getAllFamilyMembers());
  }

  Widget getAllFamilyMembers() {
    Widget familyWidget;

    return StreamBuilder<ApiResponse<FamilyMembersList>>(
      stream: _familyListBloc.familyMemberListStream,
      builder:
          (context, AsyncSnapshot<ApiResponse<FamilyMembersList>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              familyWidget = Center(
                  child: SizedBox(
                child: CircularProgressIndicator(),
                width: 30,
                height: 30,
              ));
              break;

            case Status.ERROR:
              familyWidget = Center(
                  child: Text('Oops, something went wrong',
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              familyWidget =
                  getMyFamilyMembers(snapshot.data.data.response.data);
              break;
          }
        } else {
          familyWidget = Container(
            width: 100,
            height: 100,
          );
        }
        return familyWidget;
      },
    );
  }

  Widget getMyFamilyMembers(Data data) {
    List<Sharedbyme> profilesSharedByMe = new List();

    profilesSharedByMe = data.sharedbyme;
    return profilesSharedByMe.length > 0
        ? Container(
            //padding: EdgeInsets.only(left: 10, right: 10),
            color: const Color(fhbColors.bgColorContainer),
            child: ListView.builder(
              itemBuilder: (c, i) =>
                  getCardWidgetForUser(profilesSharedByMe[i], i),
              itemCount: profilesSharedByMe.length,
            ))
        : Container(
            child: Center(
              child: Text('No Data Available'),
            ),
            color: const Color(fhbColors.bgColorContainer),
          );
  }

  Widget getCardWidgetForUser(Sharedbyme data, int position) {
    return Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFe3e2e2),
              blurRadius: 16, // has the effect of softening the shadow
              spreadRadius: 2.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Row(
          children: <Widget>[
            ClipOval(
              child: data.profileData.profilePicThumbnail == null
                  ? Image.asset(ImageUrlUtils.avatarImg, width: 60, height: 60)
                  : Image.memory(
                      Uint8List.fromList(
                          data.profileData.profilePicThumbnail.data),
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              // flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.profileData.name != null ? data.profileData.name : '',
                    style: TextStyle(fontWeight: FontWeight.w500),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    data.profileData.gender != null
                        ? data.linkedData.roleName
                        : '',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  saveMediaDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Done',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 100,
                        color: Colors.amber,
                      ),
                      _ShowSearchTextField()
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _ShowSearchTextField() {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: new TextField(
        cursorColor: Theme.of(context).primaryColor,
        controller: searchController,
        maxLines: 1,
        keyboardType: TextInputType.text,
        focusNode: searchFocus,
        textInputAction: TextInputAction.done,
//        autofocus: true,
        onSubmitted: (term) {
          searchFocus.unfocus();
        },
        style: new TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: ColorUtils.blackcolor),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () => searchController.clear(),
              icon: Icon(Icons.clear, color: ColorUtils.lightgraycolor),
            ),
            hintText: CommonConstants.searchPlaces,
            labelStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: ColorUtils.greycolor1),
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: ColorUtils.greycolor1,
              fontWeight: FontWeight.w400,
            ),
            border: new UnderlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }
}
