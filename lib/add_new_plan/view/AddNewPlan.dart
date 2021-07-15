import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/add_new_plan/block/AddNewPlanBlock.dart';
import 'package:myfhb/add_new_plan/model/PlanCode.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class AddNewPlan {
  FHBBasicWidget fhbBasicWidget = new FHBBasicWidget();
  TextEditingController planContent = new TextEditingController();
  String validationMsg;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  String feedBackType;
  String titleName;
  bool _validate = false;
  AddNewBlock _addNewPlanBlock = new AddNewBlock();

  Future<Widget> addNewPlan(BuildContext context, String feedbackCode,
      String titleNameNew, Function(bool) refresh) {
    feedBackType = feedbackCode;
    titleName = titleNameNew;
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            fhbBasicWidget.getTextTextTitleWithPurpleColor(titleName,
                fontSize: 14),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getRichTextFieldWithNoCallbacks(context, planContent,
                Constants.STR_HINT_PLAN, 150, validationMsg, (error) {
              setState(() {
                validationMsg = error;
              });
            }, true),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getSaveButton(() {


              if (!planContent.text.isEmpty) {
                onPostAddPlan(context,onRefresh: refresh);
              } else {
                validationMsg =
                    "Please Enter " + feedBackType.replaceAll("Missing", "");
                setState(() {
                  planContent.text.isEmpty
                      ? _validate = true
                      : _validate = false;
                });
              }
            }),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  void onPostAddPlan(BuildContext context, {onRefresh}) async {
      CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

      List<PlanCodeResult> planCodeResult =
          await _addNewPlanBlock.getPlanCode();

      String feedBackID = getFeedbackId(planCodeResult, feedBackType);

      Map<String, dynamic> postMediaData = new Map();
      Map<String, dynamic> postMediaFeedBack = new Map();
      postMediaFeedBack["id"] = feedBackID;
      postMediaData["feedbackType"] = postMediaFeedBack;
      postMediaData["content"] = planContent.text;
      var params = json.encode(postMediaData);
      print(params);

      _addNewPlanBlock.addNewPlan(params).then((value) {
        if (value.isSuccess) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          onRefresh(value.isSuccess);
        }else{
          Navigator.of(context).pop();

        }
      });


  }

  bool doValidationBeforePosting() {
    bool validationConditon = false;
    if (planContent.text == '') {
      validationConditon = false;
      validationMsg = "Please Enter " + feedBackType.replaceAll("Missing", "");
    } else {
      validationConditon = true;
    }
    return validationConditon;
  }

  String getFeedbackId(
      List<PlanCodeResult> planCodeResultList, String feedBackType) {
    String feedbackID;
    for (PlanCodeResult planCodeResult in planCodeResultList) {
      if (feedBackType == planCodeResult.code) {
        feedbackID = planCodeResult.id;
      }
    }

    return feedbackID;
  }
}
