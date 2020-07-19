import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/my_providers_response_list.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';

import 'my_providers_tab_bar.dart';

import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/constants/variable_constant.dart' as variable;


class MyProvidersStreamData extends StatelessWidget {
  ProvidersBloc providersBloc;
  TabController tabController;

  MyProvidersStreamData({this.providersBloc, this.tabController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MyProvidersResponseList>>(
      stream: providersBloc.providersListStream,
      builder: (context,
          AsyncSnapshot<ApiResponse<MyProvidersResponseList>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Center(
                  child: SizedBox(
                child: CircularProgressIndicator(
                  backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
                ),
                width: 30,
                height: 30,
              ));
              break;

            case Status.ERROR:
              return Center(
                  child: Text(variable.strSomethingWrong,
                      style: TextStyle(color: Colors.red)));
              break;

            case Status.COMPLETED:
              return MyProvidersTabBar(
                  data: snapshot.data.data.response.data,
                  tabController: tabController,
                  providersBloc: providersBloc);
              break;
          }
        } else {
          return Container(
            width: 100,
            height: 100,
          );
        }
      },
    );
  }
}
