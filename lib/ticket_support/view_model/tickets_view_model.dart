
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/claim/model/members/MembershipDetails.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/model/common_response.dart';
import 'package:myfhb/ticket_support/model/create_ticket_model.dart';
import 'package:myfhb/ticket_support/model/ticket_details_model.dart';
import 'package:myfhb/ticket_support/model/ticket_list_model/TicketsListResponse.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';
import 'package:myfhb/ticket_support/services/ticket_service.dart';

class TicketViewModel extends ChangeNotifier {
  UserTicketService userTicketService = UserTicketService();
  int currentTab = 0;

  // get list of tickets
  Future<TicketsListResponse?> getTicketsList() async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    if (userid != null) {
      try {
        var userTicketModel = await userTicketService.getTicketList();
        return userTicketModel;
      } catch (e,stackTrace) {
        CommonUtil().appLogs(message: e,stackTrace:stackTrace);
        print('Exception in getting list of Ticket VM Model : ${e.toString()}');
      }
    }
  }

  Future<MemberShipDetails?> getMemberShip() async {
    MemberShipDetails? memberShipDetailsResult;
    final userId =
        PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);
    if (userId != null) {
      try {
        memberShipDetailsResult = await userTicketService.getMemberShip(userId);
      } catch (e, stackTrace) {
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
    return memberShipDetailsResult;
  }

  Future<TicketDetailResponseModel?> getTicketDetail(String sId) async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    if (userid != null) {
      try {
        var userTicketModel = await userTicketService.getTicketDetails(sId);
        return userTicketModel;
      } catch (e,stackTrace) {
        CommonUtil().appLogs(message: e,stackTrace:stackTrace);

        print('Exception in getting list of Ticket VM Model : ${e.toString()}');
      }
    }
  }

  // Get list of ticket category
  Future<TicketTypesModel?> getTicketTypesList() async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    if (userid != null) {
      try {
        var userTicketTypesModel = await userTicketService.getTicketTypesList();
        return userTicketTypesModel;
      } catch (e,stackTrace) {
        CommonUtil().appLogs(message: e,stackTrace:stackTrace);

        print(
            'Exception in Get ticket category Ticket VM Model : ${e.toString()}');
      }
    }
  }

  // Create Ticket
  Future<CreateTicketModel?> createTicket() async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    var createTicketModel;
    if (userid != null) {
      try {
        createTicketModel = await userTicketService.createTicket();
      } catch (e,stackTrace) {
        CommonUtil().appLogs(message: e,stackTrace:stackTrace);

        print('Exception in Craete Ticket VM Model : ${e.toString()}');
      }
    }

    return createTicketModel;
  }

  // Comment Ticket
  Future<CommonResponse?> commentTicket() async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    if (userid != null) {
      try {
        var commentTicketModel = await userTicketService.commentTicket();
        return commentTicketModel;
      } catch (e,stackTrace) {
        CommonUtil().appLogs(message: e,stackTrace:stackTrace);

        print('Exception in Comment Ticket VM Model : ${e.toString()}');
      }
    }
  }
}
