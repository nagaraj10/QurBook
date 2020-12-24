class HomeScreenArguments {
  int selectedIndex;
  bool isCancelDialogShouldShow;
  String bookingId;
  String date;
  String doctorID;
  String doctorSessionId;
  String healthOrganizationId;
  String dialogType;
  final Map providerMap;
  String templateName;

  HomeScreenArguments({this.selectedIndex,this.isCancelDialogShouldShow,this.bookingId,this.date,this.doctorID,this.doctorSessionId,this.healthOrganizationId,this.dialogType,this.providerMap,this.templateName});
}
