import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/firebase_analytics_service.dart';
import 'package:myfhb/reminders/ReminderModel.dart';
import 'package:myfhb/telehealth/features/chat/view/full_photo.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:myfhb/common/AudioWidget.dart';
import 'package:myfhb/src/ui/SheelaAI/Views/audio_player_screen.dart';
import 'package:myfhb/src/ui/SheelaAI/Views/video_player_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/fhb_constants.dart' as Constants;
import '../../../../constants/variable_constant.dart';
import '../../../utils/screenutils/size_extensions.dart';
import '../../imageSlider.dart';
import '../Controller/SheelaAIController.dart';
import '../Models/SheelaResponse.dart';
import 'AttachmentListSheela.dart';
import 'CommonUitls.dart';
import 'youtube_player.dart';

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
                      ? Container(
                          width: CommonUtil().isTablet! ? 60.0 : 40.0,
                          child: SpinKitThreeBounce(
                              size: CommonUtil().isTablet! ? 25.0 : 18.0,
                              color: PreferenceUtil.getIfQurhomeisAcive()
                                  ? Color(
                                      CommonUtil().getQurhomeGredientColor(),
                                    )
                                  : Colors.white),
                        )
                      : (chat.audioFile ?? '').isNotEmpty
                          ? AudioWidget(
                              chat.audioFile,
                              null,
                              isFromSheela: true,
                              isPlayAudioUrl: chat?.playAudioInit ?? false,
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
                                          chat.text ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .apply(
                                                fontSizeFactor:
                                                    CommonUtil().isTablet!
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
                                    visible:
                                        ((controller.bleController == null) &&
                                            (!controller.isMuted.value)),
                                    child: Container(
                                      width: 36.0,
                                      height: 30.0,
                                      child: InkWell(
                                        onTap: () {
                                          controller.playPauseTTS(chat);
                                        },
                                        child: Icon(
                                          chat.isPlaying.isTrue
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          size: 24.0.sp,
                                          color: PreferenceUtil
                                                  .getIfQurhomeisAcive()
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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!controller.isProd)
                    Text(
                      chat.conversationFlag ?? 'Rasa',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .apply(color: Colors.grey),
                    ),
                  SizedBox(
                    height: 2,
                  ),
                  if (!PreferenceUtil.getIfQurhomeisAcive())
                    Text(
                      chat.timeStamp,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .apply(color: Colors.grey),
                    ),
                ],
              ),

              //need to add the video links here
              //if ((chat.videoLinks ?? []).isNotEmpty) videoWidgets(),
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
    String? videoId;
    videoId = YoutubePlayer.convertUrlToId(currentVideoLink.url!);
    final videoThumbnail = YoutubePlayer.getThumbnail(videoId: videoId!);
    return videoThumbnail;
  }

  Widget videoWidgets() {
    return Column(
      children: chat.videoLinks!
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
                                  color:
                                      Color(CommonUtil().getMyPrimaryColor()),
                                  iconSize: 75,
                                  onPressed: () {
                                    playYoutube(currentVideoLink.url);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      currentVideoLink.title!,
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
      return Wrap(
        spacing: 6.0,
        runSpacing: 6.0,
        children:
            List<Widget>.generate(chat?.buttons?.length ?? 0, (int index) {
          Buttons? buttonData = chat?.buttons?[index];
          return InkWell(
            onTap: ((chat.singleuse != null && chat.singleuse!) &&
                    (chat.isActionDone != null && chat.isActionDone!))
                ? null
                : () {
                    try {
                      if (buttonData?.btnRedirectTo == strPreviewScreen) {
                        if (buttonData?.chatAttachments != null &&
                            (buttonData?.chatAttachments?.length ?? 0) > 0) {
                          if (controller.isLoading.isTrue) {
                            return;
                          }
                          controller.stopTTS();
                          controller.isSheelaScreenActive = false;
                          CommonUtil()
                              .onInitQurhomeDashboardController()
                              .setActiveQurhomeDashboardToChat(status: false);
                          Get.to(
                            AttachmentListSheela(
                                chatAttachments:
                                    buttonData?.chatAttachments ?? []),
                          )?.then((value) {
                            controller.isSheelaScreenActive = true;
                            controller.playPauseTTS(chat);
                          });
                        }
                      } else if (buttonData?.btnRedirectTo ==
                          strRedirectToHelpPreview) {
                        if (buttonData?.videoUrl != null &&
                            buttonData?.videoUrl != '') {
                          playYoutube(buttonData?.videoUrl);
                        } else if (buttonData?.audioUrl != null &&
                            buttonData?.audioUrl != '') {
                          playAudioFile(buttonData?.audioUrl);
                        } else if (buttonData?.imageUrl != null &&
                            buttonData?.imageUrl != '') {
                          controller.stopTTS();
                          controller.isSheelaScreenActive = false;
                          Get.to(FullPhoto(
                            url: buttonData?.imageUrl ?? '',
                            titleSheelaPreview: strImageTitle,
                          ))?.then((value) {
                            controller.isSheelaScreenActive = true;
                            controller.playPauseTTS(chat);
                          });
                        }
                      } else if (buttonData?.btnRedirectTo == strRedirectRedo) {
                        if (controller.isLoading.isTrue) {
                          return;
                        }
                        if (chat.singleuse != null &&
                            chat.singleuse! &&
                            chat.isActionDone != null) {
                          chat.isActionDone = true;
                        }
                        buttonData?.isSelected = true;
                        controller.stopTTS();
                        controller.isLoading.value = true;
                        final cardResponse = SheelaResponse(text: buttonData?.title);
                        controller.conversations.add(cardResponse);
                        controller.scrollToEnd();
                        Future.delayed(Duration(seconds: 2), () {
                          controller.conversations
                              .add(controller.redoCurrentPlayingConversation);
                          controller.currentPlayingConversation =
                              controller.redoCurrentPlayingConversation;
                          controller.playTTS();
                          controller.scrollToEnd();
                          controller.isLoading.value = false;
                        });
                        Future.delayed(const Duration(seconds: 3), () {
                          buttonData?.isSelected = false;
                        });
                      } else if ((buttonData?.btnRedirectTo ?? "") ==
                          strHomeScreenForce.toLowerCase()) {
                        Get.back();
                      } else if ((buttonData?.isSnoozeAction ?? false)) {
                        /// we can true this condition is for if snooze enable from api
                        try {
                          var apiReminder;
                          Reminder reminder = Reminder();
                          reminder.uformname = chat.additionalInfoSheelaResponse
                                  ?.snoozeData?.uformName ??
                              '';
                          reminder.activityname = chat
                                  .additionalInfoSheelaResponse
                                  ?.snoozeData
                                  ?.activityName ??
                              '';
                          reminder.title = chat.additionalInfoSheelaResponse
                                  ?.snoozeData?.title ??
                              '';
                          reminder.description = chat
                                  .additionalInfoSheelaResponse
                                  ?.snoozeData
                                  ?.description ??
                              '';
                          reminder.eid = chat.additionalInfoSheelaResponse
                                  ?.snoozeData?.eid ??
                              '';
                          reminder.estart = chat.additionalInfoSheelaResponse
                                  ?.snoozeData?.estart ??
                              '';
                          reminder.dosemeal = chat.additionalInfoSheelaResponse
                                  ?.snoozeData?.dosemeal ??
                              '';
                          reminder.snoozeTime = CommonUtil().getTimeMillsSnooze(buttonData?.payload??'');
                          List<Reminder> data = [reminder];
                          for (var i = 0; i < data.length; i++) {
                            apiReminder = data[i];
                          }
                          if (Platform.isAndroid) {
                            // snooze invoke to android native for locally save the reminder data
                            snoozeMethodChannel.invokeMethod(
                                snoozeSheela,
                                {'data': jsonEncode(apiReminder.toMap())}).then((value) {
                              if (controller.isLoading.isTrue) {
                                return;
                              }
                              if (chat.singleuse != null &&
                                  chat.singleuse! &&
                                  chat.isActionDone != null) {
                                chat.isActionDone = true;
                              }
                              buttonData?.isSelected = true;
                              controller.startSheelaFromButton(
                                  buttonText: buttonData?.title,
                                  payload: buttonData?.payload,
                                  buttons: buttonData);
                              Future.delayed(const Duration(seconds: 3), () {
                                buttonData?.isSelected = false;
                              });
                            });
                          } else {
                            reminderMethodChannel.invokeMethod(snoozeReminderMethod, [apiReminder.toMap()]).then((value) {
                              if (controller.isLoading.isTrue) {
                                return;
                              }
                              if (chat.singleuse != null &&
                                  chat.singleuse! &&
                                  chat.isActionDone != null) {
                                chat.isActionDone = true;
                              }
                              buttonData?.isSelected = true;
                              controller.startSheelaFromButton(
                                  buttonText: buttonData?.title,
                                  payload: buttonData?.payload,
                                  buttons: buttonData);
                              Future.delayed(const Duration(seconds: 3), () {
                                buttonData?.isSelected = false;
                              });
                            });
                          }
                        } catch (e,  stackTrace) {
                          print("");
                            CommonUtil().appLogs(message: e, stackTrace: stackTrace);
                        }
                      } else {
                        if (controller.isLoading.isTrue) {
                          return;
                        }
                        if (chat.singleuse != null &&
                            chat.singleuse! &&
                            chat.isActionDone != null) {
                          chat.isActionDone = true;
                        }
                        buttonData?.isSelected = true;
                        controller.startSheelaFromButton(
                            buttonText: buttonData?.title,
                            payload: buttonData?.payload,
                            buttons: buttonData);
                        Future.delayed(const Duration(seconds: 3), () {
                          buttonData?.isSelected = false;
                        });
                      }
                    } catch (e, stackTrace) {
                      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
                    }
                  },
            child: Card(
              color: (buttonData?.isSelected ?? false)
                  ? PreferenceUtil.getIfQurhomeisAcive()
                      ? Color(CommonUtil().getQurhomeGredientColor())
                      : Colors.green
                  : (buttonData?.isPlaying.isTrue ?? false)
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
                  buttonData?.title ?? '',
                  style: TextStyle(
                    color: (buttonData?.isPlaying.isTrue ?? false) ||
                            (buttonData?.isSelected ?? false)
                        ? Colors.white
                        : PreferenceUtil.getIfQurhomeisAcive()
                            ? Color(CommonUtil().getQurhomeGredientColor())
                            : Color(CommonUtil().getMyPrimaryColor()),
                    fontSize: 14.0.sp,
                  ),
                ),
              ),
            ),
          );
        }),
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
                  Get.context!,
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
                    PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)!,
                Constants.KEY_OffSet: CommonUtil().setTimeZone()
              },
            )));
  }

  getImageURLFromCondition() {
    List<Widget> column = [];
    try {
      if ((chat.imageURL ?? []).isNotEmpty)
        return getImageFromUrl(chat.imageURL);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }

    try {
      if (chat.imageURLS != null) {
        if (chat.imageURLS!.length > 0) {
          for (String imgURL in chat.imageURLS!) {
            if (imgURL != null && imgURL != '' && imgURL != 'null') {
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
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return SizedBox.shrink();
    }
  }

  playYoutube(var currentVideoLinkUrl) {
    try {
      if (controller.isLoading.isTrue) {
        return;
      }
      String? videoId;
      videoId = YoutubePlayer.convertUrlToId(currentVideoLinkUrl);
      controller.updateTimer(enable: false);
      if (videoId != null) {
        Get.to(
          MyYoutubePlayer(
            videoId: videoId,
          ),
        )!
            .then((value) {
          controller.updateTimer(enable: true);
          controller.playPauseTTS(chat);
        });
      } else {
        controller.isPlayPauseView.value = false;
        controller.isFullScreenVideoPlayer.value =
            (CommonUtil().isTablet ?? false) ? true : false;
        Get.to(
          VideoPlayerScreen(
            videoURL: (currentVideoLinkUrl ?? ""),
          ),
        )!
            .then((value) {
          controller.updateTimer(enable: true);
          controller.playPauseTTS(chat);
        });
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  playAudioFile(var audioURLLink) {
    try {
      if (controller.isLoading.isTrue) {
        return;
      }
      controller.updateTimer(enable: false);
      Get.to(AudioPlayerScreen(
        audioUrl: (audioURLLink ?? ""),
      ))!
          .then((value) {
        controller.updateTimer(enable: true);
        controller.playPauseTTS(chat);
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }
}
