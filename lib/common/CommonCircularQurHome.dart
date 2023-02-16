import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';

class CommonCircularQurHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        Color(
          CommonUtil().getQurhomePrimaryColor(),
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.5),
    ),
  );
}
