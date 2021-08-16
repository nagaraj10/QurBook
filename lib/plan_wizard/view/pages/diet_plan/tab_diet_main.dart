import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/plan_wizard/view/pages/diet_plan/provider_diet.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:provider/provider.dart';

import '../CareDietAppBar.dart';
import 'free_diet.dart';

class TabDietMain extends StatefulWidget {
  @override
  _TabDietMainState createState() => _TabDietMainState();
}

class _TabDietMainState extends State<TabDietMain>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeTabIndex = 0;

  PlanWizardViewModel planListProvider;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_setActiveTabIndex);

    Provider.of<PlanWizardViewModel>(context, listen: false)?.currentTabDiet = 0;
    Provider.of<PlanWizardViewModel>(context, listen: false)?.currentPage = 2;
    Provider.of<PlanWizardViewModel>(context, listen: false)?.isDietListEmpty = false;
    Provider.of<PlanWizardViewModel>(context, listen: false)?.isListEmpty = false;

    if ((Provider.of<PlanWizardViewModel>(context, listen: false)
            ?.isDynamicLink) ??
        false) {
      Future.delayed(Duration(), () {
        var tabIndex = Provider.of<PlanWizardViewModel>(context, listen: false)
            ?.dynamicLinkTabIndex;
        Provider.of<PlanWizardViewModel>(context, listen: false)
            ?.changeCurrentTab(tabIndex);
        _tabController.animateTo(tabIndex);
      });
    }
  }

  void _setActiveTabIndex() {
    _activeTabIndex = _tabController.index;
    planListProvider.changeCurrentTabDiet(_activeTabIndex);
  }

  @override
  Widget build(BuildContext context) {
    planListProvider = Provider.of<PlanWizardViewModel>(context);
    return Scaffold(
      appBar: CareDietAppBar(tabController: _tabController),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(color: Color(bgColorContainer), child: ProviderDietPlans()),
          Container(color: Color(bgColorContainer), child: FreeDietPlans())
        ],
      ),
    );
  }
}
