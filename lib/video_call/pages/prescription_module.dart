import 'package:flutter/material.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';

class PrescriptionModule extends StatelessWidget {
  const PrescriptionModule();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(),
        child: Wrap(children: [
          Container(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                SizedBox(
                  height: 100.0.h,
                ),
                Visibility(
                  //visible: (appntId != null && appntId != '') ? true : false,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: 50.0.h,
                    width: 50.0.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        /*IconButton(
                            icon: ImageIcon(
                              AssetImage('assets/icons/rx.png'),
                              color: Colors.blue,
                            ),
                            onPressed: () {

                            }),*/
                        Container(
                            margin: EdgeInsets.all(10),
                            height: 50.0.h,
                            width: 50.0.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                IconButton(
                                    icon: ImageIcon(
                                      AssetImage('assets/icons/rx.png'),
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                    ),
                                    onPressed: () {
                                      FetchRecords(
                                          0, false, false, false, [], context);
                                    }),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }

  void FetchRecords(int position, bool allowSelect, bool isAudioSelect,
      bool isNotesSelect, List<String> mediaIds, BuildContext context) async {
    //NOTE: since we are already in video call, we are diable the camer and mic actions on My record - FHB-3869
    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => MyRecords(
          argument: MyRecordsArgument(
        categoryPosition: position,
        allowSelect: allowSelect,
        isAudioSelect: isAudioSelect,
        isNotesSelect: isNotesSelect,
        selectedMedias: mediaIds,
        isFromChat: false,
        isAssociateOrChat: false,
        fromClass: 'appointments',
        isFromVideoCall: true,
      )),
    ))
        .then((results) {
      if (results != null) {
        /*if (results.containsKey(STR_META_ID)) {
          healthRecordList = results[STR_META_ID] as List;
          if (healthRecordList != null) {
            getMediaURL(healthRecordList);
          }
          setState(() {});
        }*/
      }
    });
  }
}
