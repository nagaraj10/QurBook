import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/variable_constant.dart';
import '../../../utils/screenutils/size_extensions.dart';
import '../../imageSlider.dart';
import '../Controller/SheelaAIController.dart';
import '../Models/SheelaResponse.dart';
import 'CommonUitls.dart';
import 'youtube_player.dart';
import '../../../../constants/fhb_constants.dart' as Constants;

class SheelaAIReceiverBubble extends StatelessWidget {
  final SheelaResponse chat;
  SheelaAIController controller = Get.find();

  SheelaAIReceiverBubble(
    this.chat,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: PreferenceUtil.getIfQurhomeisAcive()
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30.0.sp,
          backgroundColor: Colors.white,
          child: Image.asset(
            PreferenceUtil.getStringValue(keyMayaAsset) != null
                ? '${PreferenceUtil.getStringValue(keyMayaAsset)}.png'
                : icon_maya,
            height: 32.0.h,
            width: 32.0.h,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!PreferenceUtil.getIfQurhomeisAcive())
                Text(
                  strMAYA,
                  style: Theme.of(context).textTheme.bodyText2,
                  softWrap: true,
                ),
              Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: chatBubbleBorderRadiusFor(false),
                ),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: PreferenceUtil.getIfQurhomeisAcive()
                        ? Colors.white
                        : Color(CommonUtil().getMyPrimaryColor()),
                    borderRadius: chatBubbleBorderRadiusFor(false),
                  ),
                  child: (chat.loading ?? false)
                      ? Loading(
                          indicator: BallPulseIndicator(),
                          size: 20.0,
                          color: PreferenceUtil.getIfQurhomeisAcive()
                              ? Color(
                                  CommonUtil().getQurhomeGredientColor(),
                                )
                              : Colors.white,
                        )
                      : Obx(() {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      PreferenceUtil.getIfQurhomeisAcive()
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat.text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .apply(
                                            fontSizeFactor:
                                                CommonUtil().isTablet
                                                    ? 1.6
                                                    : 1.0,
                                            color: PreferenceUtil
                                                    .getIfQurhomeisAcive()
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                    ),
                                    getImageURLFromCondition(),
                                    buttonWidgets()
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.bleController == null,
                                child: Container(
                                  width: 36.0,
                                  height: 30.0,
                                  child: InkWell(
                                    onTap: () {
                                      if (controller.isLoading.isTrue) {
                                        return;
                                      }
                                      if (chat.isPlaying.isTrue) {
                                        controller.stopTTS();
                                      } else {
                                        controller.stopTTS();
                                        controller.currentPlayingConversation =
                                            chat;
                                        controller.playTTS();
                                      }
                                    },
                                    child: Icon(
                                      chat.isPlaying.isTrue
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      size: 24.0.sp,
                                      color:
                                          PreferenceUtil.getIfQurhomeisAcive()
                                              ? Colors.black
                                              : Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                ),
              ),
              if (!PreferenceUtil.getIfQurhomeisAcive())
                Text(
                  chat.timeStamp,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .apply(color: Colors.grey),
                ),
              //need to add the video links here
              if ((chat.videoLinks ?? []).isNotEmpty) videoWidgets(),
            ],
          ),
        ),
        SizedBox(
          width: 20.0.w,
        ),
      ],
    );
  }

  String videoThumbnail(VideoLinks currentVideoLink) {
    String videoId;
    videoId = YoutubePlayer.convertUrlToId(currentVideoLink.url);
    final videoThumbnail = YoutubePlayer.getThumbnail(videoId: videoId);
    return videoThumbnail;
  }

  Widget videoWidgets() {
    return Column(
      children: chat.videoLinks
          .map(
            (currentVideoLink) => Card(
              elevation: 5,
              color: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 1.sw,
                ),
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: PreferenceUtil.getIfQurhomeisAcive()
                      ? Color(
                          CommonUtil().getQurhomeGredientColor(),
                        )
                      : Color(
                          CommonUtil().getMyPrimaryColor(),
                        ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
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
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                FadeInImage.assetNetwork(
                                  placeholder: 'assets/icons/placeholder.jpg',
                                  image: videoThumbnail(currentVideoLink),
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.play_circle_fill_rounded),
                                  color: Colors.black54,
                                  iconSize: 75,
                                  onPressed: () {
                                    if (controller.isLoading.isTrue) {
                                      return;
                                    }
                                    controller.stopTTS();
                                    String videoId;
                                    videoId = YoutubePlayer.convertUrlToId(
                                        currentVideoLink?.url);
                                    Get.to(
                                      MyYoutubePlayer(
                                        videoId: videoId,
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
                      currentVideoLink.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget buttonWidgets() {
    if ((chat.buttons ?? []).isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: chat.buttons
            .map(
              (buttonData) => InkWell(
                onTap: ((chat.singleuse != null && chat.singleuse) &&
                        (chat.isActionDone != null && chat.isActionDone))
                    ? null
                    : () {
                        if (controller.isLoading.isTrue) {
                          return;
                        }
                        if (chat.singleuse != null &&
                            chat.singleuse &&
                            chat.isActionDone != null) {
                          chat.isActionDone = true;
                        }
                        buttonData.isSelected = true;
                        controller.startSheelaFromButton(
                            buttonText: buttonData.title,
                            payload: buttonData.payload,
                            buttons: buttonData);
                        Future.delayed(const Duration(seconds: 3), () {
                          buttonData.isSelected = false;
                        });
                      },
                child: Card(
                  color: (buttonData.isSelected ?? false)
                      ? PreferenceUtil.getIfQurhomeisAcive()
                          ? Color(CommonUtil().getQurhomeGredientColor())
                          : Colors.green
                      : (buttonData.isPlaying.isTrue)
                          ? PreferenceUtil.getIfQurhomeisAcive()
                              ? Color(CommonUtil().getQurhomeGredientColor())
                              : Colors.lightBlueAccent
                          : Colors.white,
                  margin: const EdgeInsets.only(top: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    child: Text(
                      buttonData.title,
                      style: TextStyle(
                        color: (buttonData.isPlaying.isTrue) ||
                                (buttonData.isSelected ?? false)
                            ? Colors.white
                            : PreferenceUtil.getIfQurhomeisAcive()
                                ? Color(CommonUtil().getQurhomeGredientColor())
                                : Color(CommonUtil().getMyPrimaryColor()),
                        fontSize: 14.0.sp,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget getImageFromUrl(String url) {
    return Container(
        constraints: BoxConstraints(
          maxWidth: 1.sw,
        ),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: PreferenceUtil.getIfQurhomeisAcive()
              ? Color(
                  CommonUtil().getQurhomeGredientColor(),
                )
              : Color(
                  CommonUtil().getMyPrimaryColor(),
                ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  Get.context,
                  MaterialPageRoute(
                      builder: (context) => ImageSlider(
                            imageURl: url,
                          )));
            },
            child: Image.network(
              url,
              fit: BoxFit.fill,
              width: 200.0.h,
              height: 200.0.h,
              headers: {
                HttpHeaders.authorizationHeader:
                    PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN),
                Constants.KEY_OffSet: CommonUtil().setTimeZone()
              },
            )));
  }

  getImageURLFromCondition() {
    List<Widget> column = [];
    try {
      if ((chat.imageURL ?? []).isNotEmpty)
        return getImageFromUrl(chat.imageURL);
    } catch (e) {}

    if (chat.imageURLS != null) {
      if (chat.imageURLS.length > 0) {
        for (String imgURL in chat.imageURLS) {
          if (imgURL != null && imgURL != '') {
            column.add(getImageFromUrl(imgURL));
          }
        }
        if (column.length > 0) {
          return Container(
              child: Column(
            children: column,
          ));
        } else {
          return SizedBox.shrink();
        }
      }
    } else {
      return SizedBox.shrink();
    }
  }
}
