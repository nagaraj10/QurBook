import 'package:flutter/material.dart';
import '../../constants/fhb_query.dart' as query;
import '../../constants/webservice_call.dart';
import '../models/FamilyMembersResponse.dart';
import '../models/relationship_response_list.dart';
import '../../src/resources/network/ApiBaseHelper.dart';

class MyFamilyViewModel with ChangeNotifier {
  // Api Base Helper
  final ApiBaseHelper _helper = ApiBaseHelper();
  WebserviceCall webserviceCall = WebserviceCall();

  // 1
  // Get the family members list
  FamilyMembersList familyMembersList;

  // 2
  // Get the relationship list
  RelationShipResponseList relationShipResponseList;

  // 1
  // Get Family Members
  Future<FamilyMembersList> getFamilyMembersInfo() async {
    try {
      var response = await _helper
          .getFamilyMembersList(webserviceCall.getQueryForFamilyMemberList());
      familyMembersList = FamilyMembersList.fromJson(response);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  // 2
  // Get Roles
  Future<RelationShipResponseList> getCustomRoles() async {
    try {
      var response =
          await _helper.getCustomRoles(query.qr_customRole);
      relationShipResponseList = RelationShipResponseList.fromJson(response);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
