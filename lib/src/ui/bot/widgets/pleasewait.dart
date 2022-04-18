import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import '../../../../common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class PleaseWait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              variable.strtapToSpeak,
              style: TextStyle(
                fontSize: 25.0.sp,
                color: PreferenceUtil.getIfQurhomeisAcive()
                    ? Color(
                        CommonUtil().getQurhomeGredientColor(),
                      )
                    : Color(
                        CommonUtil().getMyPrimaryColor(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
