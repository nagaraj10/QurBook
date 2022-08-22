///
/// `alert.dart`
/// Class contains static methods to show alerts
///

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/common/CommonUtil.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class Alert {
  static Future displayAlertPlain(
    BuildContext context, {
    String title = '',
    String content = '',
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }

  static Future displayAlert(
    BuildContext context, {
    String title = '',
    String content = '',
    String confirm = variable.strOK,
    Function onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text(confirm),
              onPressed: onPressed ??
                  () {
                    Navigator.of(context).pop();
                  },
            )
          ],
        );
      },
    );
  }

  static Future displayConfirmProceed(
    BuildContext context, {
    String title = '',
    String content = '',
    String cancel = variable.strCANCEL,
    String confirm = variable.strOK,
    Function onPressedCancel,
    Function onPressedConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.grey,
              child: Text(cancel),
              onPressed: onPressedCancel ??
                  () {
                    Navigator.of(context).pop();
                  },
            ),
            FlatButton(
              textColor: Colors.white,
              color: Color(CommonUtil().getMyPrimaryColor()),
              child: Text(confirm),
              onPressed: onPressedConfirm ??
                  () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
            )
          ],
        );
      },
    );
  }

  static Future displayConfirmation(
    BuildContext context, {
    String title = '',
    String content = '',
    String confirm = variable.strOKAY,
    Function onPressedCancel,
    Function onPressedConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              color: Color(CommonUtil().getMyPrimaryColor()),
              child: Text(confirm),
              onPressed: onPressedConfirm ??
                  () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
            )
          ],
        );
      },
    );
  }

  static Future displayConfirmationWithCloseIcon(
    BuildContext context, {
    String title = '',
    String content = '',
    String confirm = variable.strOKAY,
    Function onPressedCancel,
    Function onPressedConfirm,
  }) {
    final dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            color: Color(CommonUtil().getMyPrimaryColor()),
            child: Text(confirm),
            onPressed: onPressedConfirm ??
                () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
          )
        ],
      );
    });

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialog);
  }
}
