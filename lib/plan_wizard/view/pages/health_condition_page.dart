import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/plan_wizard/models/health_condition_response_model.dart';
import 'package:myfhb/plan_wizard/view/widgets/plans_grid_view.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:provider/provider.dart';

class HealthConditionPage extends StatefulWidget {
  @override
  _HealthConditionPageState createState() => _HealthConditionPageState();
}

class _HealthConditionPageState extends State<HealthConditionPage> {
  Future<Map<String, List<MenuItem>>> healthConditions;

  @override
  void initState() {
    super.initState();
    healthConditions = Provider.of<PlanWizardViewModel>(context, listen: false)
        .getHealthConditions();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SearchWidget(onChanged: (value) {}, hintText: strSearchHealth),
          Expanded(
            child: FutureBuilder<Map<String, List<MenuItem>>>(
                future: healthConditions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SafeArea(
                      child: SizedBox(
                        height: 1.sh / 4.5,
                        child: Center(
                          child: SizedBox(
                            width: 30.0.h,
                            height: 30.0.h,
                            child: CircularProgressIndicator(
                                backgroundColor:
                                    Color(CommonUtil().getMyPrimaryColor())),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return ErrorsWidget();
                  } else {
                    var healthConditionsList = snapshot.data;
                    if ((healthConditionsList?.length ?? 0) > 0) {
                      return SingleChildScrollView(
                        child: Column(
                          children: getPlansGrid(healthConditionsList),
                        ),
                      );
                    } else {
                      return SafeArea(
                        child: SizedBox(
                          height: 1.sh / 1.3,
                          child: Container(
                            child: Center(
                              child: Text(strNoHealthConditions),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                }),
          ),
        ],
      );

  List<Widget> getPlansGrid(Map<String, List<MenuItem>> healthConditionsList) {
    var planCategories = <Widget>[];
    healthConditionsList?.forEach(
      (categoryName, menuItemList) {
        planCategories.add(
          PlansGridView(
            title: toBeginningOfSentenceCase(categoryName ?? ''),
            planList: menuItemList,
          ),
        );
      },
    );
    return planCategories;
  }
}
