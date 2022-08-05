import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/ui/bot/widgets/maya_conv_ui.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../model/bot/ConversationModel.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';

class ReceiverLayout extends StatefulWidget {
  final Conversation c;
  final int index;

  ReceiverLayout(
    this.c,
    this.index,
  );

  @override
  _ReceiverLayoutState createState() => _ReceiverLayoutState();
}

class _ReceiverLayoutState extends State<ReceiverLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // closeIfByeSaid();
  }

  void closeIfByeSaid() async {
    if (widget?.c?.redirect != null && widget?.c?.screen != null) {
      if (widget?.c?.screen == parameters.strDashboard && widget?.c?.redirect) {
        Provider.of<ChatScreenViewModel>(context, listen: false).stopTTSEngine(
          index: widget.index,
          langCode: widget.c.langCode,
        );
        Future.delayed(Duration(seconds: 9), () => Navigator.pop(context));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: PreferenceUtil.getIfQurhomeisAcive()
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          child: Image.asset(
            PreferenceUtil.getStringValue(constants.keyMayaAsset) != null
                ? PreferenceUtil.getStringValue(constants.keyMayaAsset) + '.png'
                : variable.icon_maya,
            height: 32.0.h,
            width: 32.0.h,
          ),
          radius: 30.0.sp,
          backgroundColor: Colors.white,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PreferenceUtil.getIfQurhomeisAcive()
                  ? Container()
                  : Text(
                      variable.strMAYA,
                      style: Theme.of(context).textTheme.body1,
                      softWrap: true,
                    ),
              Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                      25,
                    ),
                    topLeft: PreferenceUtil.getIfQurhomeisAcive()
                        ? Radius.circular(25)
                        : Radius.zero,
                    bottomLeft: PreferenceUtil.getIfQurhomeisAcive()
                        ? Radius.zero
                        : Radius.circular(25),
                    bottomRight: Radius.circular(
                      25,
                    ),
                  ),
                ),
                child: Container(
                  // constraints: BoxConstraints(
                  //   maxWidth: 1.sw * .6,
                  // ),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: PreferenceUtil.getIfQurhomeisAcive()
                        ? Colors.white
                        : Color(CommonUtil().getMyPrimaryColor()),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomLeft: PreferenceUtil.getIfQurhomeisAcive()
                          ? Radius.zero
                          : Radius.circular(25),
                      bottomRight: Radius.circular(25),
                      topLeft: PreferenceUtil.getIfQurhomeisAcive()
                          ? Radius.circular(25)
                          : Radius.zero,
                    ),
                  ),
                  child: FutureBuilder(
                    future: (widget.c.loadingDots ?? false)
                        ? Future.delayed(
                            Duration(
                              seconds: 3,
                            ),
                            () => MayaConvUI(widget.c, widget.index),
                          )
                        : Future.value(
                            MayaConvUI(widget.c, widget.index),
                          ),
                    builder: (BuildContext context, snapshot) {
                      return snapshot.hasData
                          ? snapshot.data
                          : Loading(
                              indicator: BallPulseIndicator(),
                              size: 20.0,
                              color: Colors.white,
                            );
                    },
                  ),
                ),
              ),
              widget?.c?.provider_msg
                  ? Text(
                      variable.strMsgFromProvider,
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: 12),
                    )
                  : SizedBox.shrink(),
              PreferenceUtil.getIfQurhomeisAcive()
                  ? Container()
                  : widget.c.timeStamp==null||widget.c.timeStamp=="null" ?
              Container() :Text(
                      "${widget.c.timeStamp}",
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .apply(color: Colors.grey),
                    ),
            ],
          ),
        ),
        SizedBox(width: 20.0.w),
      ],
    );
  }
}
