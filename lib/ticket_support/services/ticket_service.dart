import 'dart:io';

import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/src/model/common_response.dart';
import 'package:myfhb/src/model/common_response_model.dart';
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/ticket_support/model/create_ticket_model.dart';
import 'package:myfhb/ticket_support/model/ticket_details_model.dart';
import 'package:myfhb/ticket_support/model/ticket_list_model/TicketsListResponse.dart';
import 'package:myfhb/ticket_support/model/ticket_model.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';
import 'package:myfhb/ticket_support/model/user_comments_model.dart';
import '../../../constants/fhb_constants.dart' as Constants;

class UserTicketService {
  ApiBaseHelper _helper = ApiBaseHelper();
  TicketsListResponse _userTicketModel = TicketsListResponse();
  TicketDetailResponseModel _userTicketDetailModel =
      TicketDetailResponseModel();
  TicketTypesModel _ticketTypesModel = TicketTypesModel();
  CreateTicketModel _createTicketModel = CreateTicketModel();
  UserCommentsModel _userCommentModel = UserCommentsModel();

  // Get List of tickets -- Yogeshwar
  Future<TicketsListResponse> getTicketList() async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    final response =
        await _helper.getTicketList('${query.qr_get_tickets}${'/$userid'}');
    _userTicketModel = TicketsListResponse.fromJson(response["result"]);
    return _userTicketModel;
  }

  Future<TicketDetailResponseModel> getTicketDetails(String sId) async {
    final userid = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    final response =
        await _helper.getTicketList('${query.qr_get_ticket_details}${'/$sId'}');
    _userTicketDetailModel = TicketDetailResponseModel.fromJson(response);
    return _userTicketDetailModel;
  }

  Future<bool> uploadAttachment(String ticketId, File image) async {
    final res = await _helper.uploadAttachment(
        query.qr_upload_attachment, ticketId, image);
    // final response = CommonResponseModel.fromJson(res);
    return res;
  }

  // Get List of ticket types -- Yogeshwar
  Future<TicketTypesModel> getTicketTypesList() async {
    final response =
        await _helper.getTicketTypesList(query.qr_get_ticket_types);
    _ticketTypesModel = TicketTypesModel.fromJson(response);
    print(
        'User Ticket Types Reponse : ${_ticketTypesModel.ticketTypeResults.asMap()}');
    return _ticketTypesModel;
  }

  // Create Ticket
  Future<CreateTicketModel> createTicket() async {
    final response = await _helper.createTicket(query.qr_create_ticket);
    _createTicketModel = CreateTicketModel.fromJson(response);
    /*print(
        'User Create Ticket Reponse : ${_createTicketModel.result.ticket.toJson()}');*/
    return _createTicketModel;
  }

  // raise comment for the ticket
  Future<CommonResponse> commentTicket() async {
    final response = await _helper.commentsForTicket(query.qr_comment_ticket);
    CommonResponse _userCommentModels = CommonResponse.fromJson(response);

    return _userCommentModels;
  }
}
