import 'package:myfhb/constants/fhb_query.dart' as query;
import 'package:myfhb/src/resources/network/ApiBaseHelper.dart';
import 'package:myfhb/ticket_support/model/create_ticket_model.dart';
import 'package:myfhb/ticket_support/model/ticket_model.dart';
import 'package:myfhb/ticket_support/model/ticket_types_model.dart';

class UserTicketService {
  ApiBaseHelper _helper = ApiBaseHelper();
  UserTicketModel _userTicketModel = UserTicketModel();
  TicketTypesModel _ticketTypesModel = TicketTypesModel();
  CreateTicketModel _createTicketModel = CreateTicketModel();

  // Get List of tickets -- Yogeshwar
  Future<UserTicketModel> getTicketList() async {
    final response = await _helper.getTicketList(query.qr_get_tickets);
    _userTicketModel = UserTicketModel.fromJson(response);
    print('User Tickets Reponse : ${_userTicketModel.result.toJson()}');
    return _userTicketModel;
  }

  // Get List of ticket types -- Yogeshwar
  Future<TicketTypesModel> getTicketTypesList() async {
    final response = await _helper.getTicketTypesList(query.qr_get_ticket_types);
    _ticketTypesModel = TicketTypesModel.fromJson(response);
    print('User Ticket Types Reponse : ${_ticketTypesModel.ticketTypeResults.asMap()}');
    return _ticketTypesModel;
  }

  // Create Ticket
  Future<CreateTicketModel> createTicket() async {
    final response = await _helper.createTicket(query.qr_create_ticket);
    _createTicketModel = CreateTicketModel.fromJson(response);
    print('User Create Ticket Reponse : ${_createTicketModel.result.ticket.toJson()}');
    return _createTicketModel;
  }
}
