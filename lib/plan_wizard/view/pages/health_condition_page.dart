import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../common/common_circular_indicator.dart';
import '../../../common/errors_widget.dart';
import '../../../constants/fhb_constants.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../models/health_condition_response_model.dart';
import '../../view_model/plan_wizard_view_model.dart';
import '../widgets/plans_grid_view.dart';

class HealthConditionPage extends StatefulWidget {
  @override
  _HealthConditionPageState createState() => _HealthConditionPageState();
}

class _HealthConditionPageState extends State<HealthConditionPage> {
  late Future<Map<String?, List<MenuItem>>?> healthConditions;

  @override
  void initState() {
    super.initState();
    Provider.of<PlanWizardViewModel>(context, listen: false).isHealthSearch =
        false;

    Provider.of<PlanWizardViewModel>(context, listen: false).isListEmpty =
        false;

    healthConditions = Provider.of<PlanWizardViewModel>(context, listen: false)
        .getHealthConditions();

    Provider.of<PlanWizardViewModel>(context, listen: false).currentTab = 0;
    Provider.of<PlanWizardViewModel>(context, listen: false).currentPage = 0;
    Provider.of<PlanWizardViewModel>(context, listen: false).isListEmpty =
        false;
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // SearchWidget(
          //   hintText: strSearchHealth,
          //   onChanged: (value) {
          //     Provider.of<PlanWizardViewModel>(context, listen: false)
          //         .getFilteredHealthConditions(value);
          //   },
          // ),
          Expanded(
            child: FutureBuilder<Map<String?, List<MenuItem>>?>(
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
                            child: CommonCircularIndicator(),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return ErrorsWidget();
                  } else {
                    var healthConditionsList =
                        (Provider.of<PlanWizardViewModel>(context)
                                .isHealthSearch)
                            ? (Provider.of<PlanWizardViewModel>(context,
                                    listen: false)
                                .filteredHealthConditions)
                            : (Provider.of<PlanWizardViewModel>(context,
                                    listen: false)
                                .healthConditions);
                    if ((healthConditionsList.length) > 0) {
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

  List<Widget> getPlansGrid(Map<String?, List<MenuItem>> healthConditionsList) {
    var planCategories = <Widget>[];
    healthConditionsList.forEach(
      (categoryName, menuItemList) {
        planCategories.add(
          PlansGridView(
            title: toBeginningOfSentenceCase(categoryName),
            planList: menuItemList,
          ),
        );
      },
    );
    return planCategories;
  }
}
