import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/plan_wizard/view/pages/care_plan/care_plan_page.dart';
import 'package:myfhb/plan_wizard/view/pages/care_plan/provider_care.dart';
import 'package:myfhb/plan_wizard/view_model/plan_wizard_view_model.dart';
import 'package:provider/provider.dart';

import '../CareDietAppBar.dart';
import 'free_care.dart';

class TabCareMain extends StatefulWidget {
  @override
  _TabCareMainState createState() => _TabCareMainState();
}

class _TabCareMainState extends State<TabCareMain>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _activeTabIndex = 0;

  PlanWizardViewModel planListProvider;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_setActiveTabIndex);

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
    } else {
      Provider.of<PlanWizardViewModel>(context, listen: false)?.currentTab = 0;
      Provider.of<PlanWizardViewModel>(context, listen: false)?.currentPage = 1;
    }
    Provider.of<PlanWizardViewModel>(context, listen: false)?.isListEmpty =
        false;
    Provider.of<PlanWizardViewModel>(context, listen: false)?.isDietListEmpty =
        false;
  }

  void _setActiveTabIndex() {
    FocusManager.instance.primaryFocus.unfocus();
    _activeTabIndex = _tabController.index;
    planListProvider.changeCurrentTab(_activeTabIndex);
  }

  @override
  Widget build(BuildContext context) {
    planListProvider = Provider.of<PlanWizardViewModel>(context);
    return Scaffold(
      appBar: CareDietAppBar(tabController: _tabController),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(color: Color(bgColorContainer), child: ProviderCarePlans()),
          Container(color: Color(bgColorContainer), child: FreeCarePlans())
        ],
      ),
    );
  }
}
