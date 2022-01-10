import 'package:flutter/material.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/landing/model/membership_detail_response.dart';
import 'package:myfhb/src/model/user/MyProfileResult.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';

class CorpUsersWelcomeDialog extends StatelessWidget {
  const CorpUsersWelcomeDialog(this.cpUser, this.result, {Key key})
      : super(key: key);
  final Result result;
  final MyProfileResult cpUser;
  @override
  Widget build(BuildContext context) {
    String firstName=cpUser.firstName??'';
    String lastName=cpUser.lastName??'';
    return Dialog(
      insetPadding: EdgeInsets.only(left: 25, right: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 15),
                  Text(
                    welcome,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  SizedBox(height: 15),
                  Text(
                    firstName+' '+lastName,
                    style: TextStyle(
                        color: themeColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  SizedBox(height: 15),
                  Text(
                    corporate,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    result.healthOrganizationName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                  SizedBox(height: 8),
                  Text(
                    careEmployees,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                  // SizedBox(height: 15),
                  // Text(
                  //   membership,
                  //   style: TextStyle(
                  //       fontStyle: FontStyle.italic,
                  //       color: Colors.grey[400],
                  //       fontWeight: FontWeight.normal,
                  //       fontSize: 16),
                  // ),
                  SizedBox(height: 5),
                  Text(
                    result.planName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(height: 25),
                  Center(
                    child: Text(
                      longDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 25),
                  getStartedButton(context),
                  SizedBox(height: 25),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ),
    );
  }

  Widget getStartedButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            PreferenceUtil.isCorpUserWelcomeMessageDialogShown(true);
            Navigator.pop(context, true);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(end: Alignment.centerRight, colors: [
//                  Color(0xff138fcf),
//                  Color(0xff138fcf),
                  Color(CommonUtil().getMyPrimaryColor()),
                  Color(CommonUtil().getMyGredientColor())
                ])),
            child: Text(
              getStarted,
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
