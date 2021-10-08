import 'dart:ui';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:myfhb/constants/fhb_constants.dart' as constants;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/ui/bot/common/botutils.dart';
import 'package:myfhb/src/ui/bot/widgets/maya_conv_ui.dart';
import 'package:myfhb/src/ui/bot/widgets/youtube_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../model/bot/ConversationModel.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class ReceiverLayoutWithIntroVideo extends StatelessWidget {
  final Conversation c;
  final int index;

  ReceiverLayoutWithIntroVideo(
    this.c,
    this.index,
  );
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(
                variable.strMAYA,
                style: Theme.of(context).textTheme.body1,
                softWrap: true,
              ),
              Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
                child: Container(
                  // constraints: BoxConstraints(
                  //   maxWidth: 1.sw * .6,
                  // ),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Color(CommonUtil().getMyPrimaryColor()),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: FutureBuilder(
                    future: Future.delayed(
                        Duration(seconds: 3), () => MayaConvUI(c, index)),
                    builder: (BuildContext context, snapshot) {
                      return snapshot.hasData
                          ? snapshot.data
                          : Loading(
                              indicator: BallPulseIndicator(),
                              size: 20.0,
                              color: Colors.white);
                    },
                  ),
                ),
              ),
              Text(
                "${c.timeStamp}",
                style:
                    Theme.of(context).textTheme.body1.apply(color: Colors.grey),
              ),
              SizedBox(width: 10.0.w),
              Column(
                children: [
                  Card(
                    elevation: 5,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 1.sw,
                        //maxHeight: 280,
                      ),
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Color(CommonUtil().getMyPrimaryColor()),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 1.sw,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/icons/placeholder.jpg',
                                        image: videoThumbnail(0),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                            Icons.play_circle_fill_rounded),
                                        color: Colors.black54,
                                        iconSize: 75,
                                        onPressed: () {
                                          stopTTSEngine();
                                          String videoId;
                                          videoId =
                                              YoutubePlayer.convertUrlToId(
                                                  c?.videoLinks[0]?.url);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyYoutubePlayer(
                                                videoId: videoId,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            c?.videoLinks[0]?.title,
                            style: TextStyle(
                                color: Colors.white, fontSize: 15.0.sp),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 1.sw,
                        //maxHeight: 200,
                      ),
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Color(CommonUtil().getMyPrimaryColor()),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 1.sw,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/icons/placeholder.jpg',
                                        image: videoThumbnail(1),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                            Icons.play_circle_fill_rounded),
                                        color: Colors.black54,
                                        iconSize: 75,
                                        onPressed: () {
                                          stopTTSEngine();
                                          String videoId;
                                          videoId =
                                              YoutubePlayer.convertUrlToId(
                                                  c?.videoLinks[1]?.url);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyYoutubePlayer(
                                                videoId: videoId,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            c?.videoLinks[1]?.title,
                            style: TextStyle(
                                color: Colors.white, fontSize: 15.0.sp),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 1.sw,
                        //maxHeight: 200,
                      ),
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Color(CommonUtil().getMyPrimaryColor()),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 1.sw,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/icons/placeholder.jpg',
                                        image: videoThumbnail(2),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                            Icons.play_circle_fill_rounded),
                                        color: Colors.black54,
                                        iconSize: 75,
                                        onPressed: () {
                                          stopTTSEngine();
                                          String videoId;
                                          videoId =
                                              YoutubePlayer.convertUrlToId(
                                                  c?.videoLinks[2]?.url);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyYoutubePlayer(
                                                videoId: videoId,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            c?.videoLinks[2]?.title,
                            style: TextStyle(
                                color: Colors.white, fontSize: 15.0.sp),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 1.sw,
                        //maxHeight: 200,
                      ),
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Color(CommonUtil().getMyPrimaryColor()),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 1.sw,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/icons/placeholder.jpg',
                                        image: videoThumbnail(3),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                            Icons.play_circle_fill_rounded),
                                        color: Colors.black54,
                                        iconSize: 75,
                                        onPressed: () {
                                          stopTTSEngine();
                                          String videoId;
                                          videoId =
                                              YoutubePlayer.convertUrlToId(
                                                  c?.videoLinks[3]?.url);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MyYoutubePlayer(
                                                videoId: videoId,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            c?.videoLinks[3]?.title,
                            style: TextStyle(
                                color: Colors.white, fontSize: 15.0.sp),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 20.0.w),
      ],
    );
  }

  String videoThumbnail(int index) {
    String videoId;
    videoId = YoutubePlayer.convertUrlToId(c?.videoLinks[index]?.url);
    var videoThumbnail = YoutubePlayer.getThumbnail(videoId: videoId);
    return videoThumbnail;
  }

  stopTTSEngine() async {
    await variable.tts_platform.invokeMethod(variable.strtts, {
      parameters.strMessage: "",
      parameters.strIsClose: true,
      parameters.strLanguage: Utils.getCurrentLanCode()
    });
  }
}
