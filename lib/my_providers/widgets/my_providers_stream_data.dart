import 'package:flutter/material.dart';
import '../../common/CommonUtil.dart';
import '../../constants/variable_constant.dart' as variable;
import '../bloc/providers_block.dart';
import '../models/MyProviderResponseNew.dart';
import '../models/my_providers_response_list.dart';
import '../../src/resources/network/ApiResponse.dart';
import '../../src/utils/screenutils/size_extensions.dart';

import 'my_providers_tab_bar.dart';

class MyProvidersStreamData extends StatelessWidget {
  ProvidersBloc providersBloc;
  TabController tabController;

  MyProvidersStreamData({this.providersBloc, this.tabController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MyProvidersResponse>>(
      stream: providersBloc.providersListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CircularProgressIndicator(
                  backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
                ),
              ));
              break;

            case Status.ERROR:
              return Center(
                  child: Text(variable.strSomethingWrong,
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              return MyProvidersTabBar(
                  data: snapshot.data.data.result,
                  tabController: tabController,
                  providersBloc: providersBloc);
              break;
          }
        } else {
          return Container(
            width: 100.0.h,
            height: 100.0.h,
          );
        }
      },
    );
  }
}
