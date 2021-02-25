import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';

class MyRecordsArgument {
  int categoryPosition;
  bool allowSelect;
  bool isNotesSelect;
  bool isAudioSelect;
  List<String> selectedMedias;
  bool isFromChat;
  bool showDetails;
  List<HealthRecordCollection> selectedRecordIds;
  bool isAssociateOrChat;
  bool isFromBills;
  String userID;
  bool fromAppointments;
  String fromClass;

  MyRecordsArgument(
      {this.categoryPosition,
      this.allowSelect,
      this.isAudioSelect,
      this.isNotesSelect,
      this.selectedMedias,
      this.isFromChat,
      this.showDetails,
      this.selectedRecordIds,
      this.isAssociateOrChat,
      this.isFromBills,
      this.userID,
      this.fromAppointments,
      this.fromClass});
}
