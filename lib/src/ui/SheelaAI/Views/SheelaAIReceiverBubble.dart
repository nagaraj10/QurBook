import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/reminders/QurPlanReminders.dart';
import 'package:myfhb/reminders/ReminderModel.dart';
import 'package:myfhb/telehealth/features/chat/view/full_photo.dart';
import 'package:photo_view/photo_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:myfhb/common/AudioWidget.dart';
import 'package:myfhb/src/ui/SheelaAI/Views/audio_player_screen.dart';
import 'package:myfhb/src/ui/SheelaAI/Views/video_player_screen.dart';

import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/fhb_constants.dart' as Constants;
import '../../../../constants/variable_constant.dart';
import '../../../utils/screenutils/size_extensions.dart';
import '../../audio/AudioRecorder.dart';
import '../../audio/AudioScreenArguments.dart';
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
                                        // Conditional rendering of an image preview thumbnail
                                        (chat.imageThumbnailUrl != null &&
                                            chat.imageThumbnailUrl != '')
                                            ? getImagePreviewThumbnail(chat.imageThumbnailUrl??'')
                                            : SizedBox.shrink(),
                                        buttonWidgets(context)
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
                                  placeholder: ic_placeholder,
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

  Widget buttonWidgets(BuildContext context) {
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
                          reminder.estart = CommonUtil()
                              .snoozeDataFormat(DateTime.now().add(Duration(
                              minutes: int.parse(buttonData?.payload ?? '0'))))
                              .toString();
                          reminder.dosemeal = chat.additionalInfoSheelaResponse
                                  ?.snoozeData?.dosemeal ??
                              '';
                          reminder.snoozeTime = CommonUtil()
                              .getTimeMillsSnooze(buttonData?.payload ?? '');
                          reminder.tplanid = '0';
                          reminder.teid_user = '0';
                          reminder.remindin = '0';
                          reminder.remindin_type = '0';
                          reminder.providerid = '0';
                          reminder.remindbefore = '0';
                          List<Reminder> data = [reminder];
                          for (var i = 0; i < data.length; i++) {
                            apiReminder = data[i];
                          }
                          if (Platform.isAndroid) {
                              QurPlanReminders.getTheRemindersFromAPI(
                                  isSnooze: true,
                                  snoozeReminderData: apiReminder);
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
                      } else if (buttonData?.needPhoto ?? false) {
                        // Check if the button requires a photo
                        if (controller.isLoading.isTrue) {
                          return; // If loading, do nothing
                        }
                        controller.stopTTS(); // Stop Text-to-Speech
                        controller.updateTimer(enable: false); // disable the timer
                        controller.isSheelaScreenActive = false; // Deactivate Sheela screen
                        controller.btnTextLocal = buttonData?.title ?? ''; // Set local button text
                        // Show the camera/gallery dialog and handle the result
                        controller.showCameraGalleryDialog(controller.btnTextLocal ?? '').then((value) {
                          controller.isSheelaScreenActive = true; // Reactivate Sheela screen after dialog
                          controller.updateTimer(enable: true); // enable the timer
                        });
                      } else if (buttonData?.btnRedirectTo == strRedirectRetakePicture) {
                        // Check if the button redirects to retake picture
                        if (controller.isLoading.isTrue) {
                          return; // If loading, do nothing
                        }
                        controller.stopTTS(); // Stop Text-to-Speech
                        controller.isSheelaScreenActive = false; // Deactivate Sheela screen
                        controller.updateTimer(enable: false); // disable the timer
                        controller.isRetakeCapture = true; // Set flag for retake capture
                        // Show the camera/gallery dialog and handle the result
                        controller.showCameraGalleryDialog(controller.btnTextLocal ?? '').then((value) {
                          controller.isSheelaScreenActive = true; // Reactivate Sheela screen after dialog
                          controller.updateTimer(enable: true); // enable the timer
                        });
                      } else if (buttonData?.btnRedirectTo == strRedirectToUploadImage) {
                        // Check if the button redirects to upload image
                        controller.isLoading.value = true; // Set loading flag
                        controller.conversations.add(SheelaResponse(loading: true)); // Add loading response to conversations
                        controller.scrollToEnd(); // Scroll to the end of conversations
                        if (chat.imageThumbnailUrl != null && chat.imageThumbnailUrl != '') {
                          // Check if there is a valid image thumbnail URL
                          controller
                              .saveMediaRegiment(chat.imageThumbnailUrl ?? '', '') // Save media regiment
                              .then((value) {
                            controller.isLoading.value = false; // Reset loading flag
                            controller.conversations.removeLast(); // Remove the loading response from conversations
                            if (value.isSuccess ?? false) {
                              controller.imageRequestUrl =
                                  value.result?.accessUrl ?? '';
                              if (controller.isLoading.isTrue) {
                                return; // If loading, do nothing
                              }
                              if (chat.singleuse != null && chat.singleuse! && chat.isActionDone != null) {
                                chat.isActionDone = true; // Set action done flag if it's a single-use button
                              }
                              buttonData?.isSelected = true; // Mark the button as selected
                              // Start Sheela from the button with specified parameters
                              controller.startSheelaFromButton(
                                buttonText: buttonData?.title,
                                payload: buttonData?.payload,
                                buttons: buttonData,
                                isFromImageUpload: true
                              );
                              // Delay for 3 seconds and then unselect the button
                              Future.delayed(const Duration(seconds: 3), () {
                                buttonData?.isSelected = false;
                              });
                            }
                          });
                        }
                      }else if (buttonData?.needAudio ?? false) {
                        if (controller.isLoading.isTrue) {
                          return;
                        }
                        controller.stopTTS();
                        controller.updateTimer(enable: false);
                        controller.isSheelaScreenActive = false;
                        controller.btnTextLocal = buttonData?.title ?? '';
                        goToAudioRecordScreen();
                      }else if (buttonData?.btnRedirectTo == strRedirectRetakeAudio) {
                        if (controller.isLoading.isTrue) {
                          return;
                        }
                        controller.stopTTS();
                        controller.isSheelaScreenActive = false;
                        controller.updateTimer(enable: false);
                        controller.isRetakeCapture = true;
                        goToAudioRecordScreen();
                      }else if (buttonData?.btnRedirectTo == strRedirectToUploadAudio) {
                        controller.isLoading.value = true;
                        controller.conversations.add(SheelaResponse(loading: true));
                        controller.scrollToEnd();
                        if (chat.imageThumbnailUrl != null && chat.imageThumbnailUrl != '') {
                          controller
                              .saveMediaRegiment(chat.imageThumbnailUrl ?? '', '')
                              .then((value) {
                            controller.isLoading.value = false;
                            controller.conversations.removeLast();
                            if (value.isSuccess ?? false) {
                              controller.imageRequestUrl =
                                  value.result?.accessUrl ?? '';
                              if (controller.isLoading.isTrue) {
                                return;
                              }
                              if (chat.singleuse != null && chat.singleuse! && chat.isActionDone != null) {
                                chat.isActionDone = true;
                              }
                              buttonData?.isSelected = true;
                              controller.startSheelaFromButton(
                                  buttonText: buttonData?.title,
                                  payload: buttonData?.payload,
                                  buttons: buttonData,
                                  isFromImageUpload: true
                              );
                              Future.delayed(const Duration(seconds: 3), () {
                                buttonData?.isSelected = false;
                              });
                            }
                          });
                        }
                      }else {
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
                child: (buttonData?.isImageWithContent ?? false) // Check if the button has both image and text content
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 1.sw,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Navigate to the ImageSlider page with the media content from buttonData, or an empty string if null.
                                    controller.stopTTS();
                                    controller.isSheelaScreenActive = false;
                                    Get.to(() => ImageSlider(
                                          imageURl: (buttonData?.media ?? ''), // Pass the image link to the ImageSlider widget.
                                        ))?.then((value) {
                                      controller.isSheelaScreenActive = true;
                                      controller.playPauseTTS(chat);
                                    });
                                  },
                                  child: FadeInImage.assetNetwork(
                                    placeholder: ic_placeholder,
                                    image: (buttonData?.media ?? ''),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.0.h,
                          ),
                          getButtonTextWidget(buttonData),
                        ],
                      )
                    : getButtonTextWidget(buttonData), // Display button text if there is no image content
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
              // Navigate to the ImageSlider page with the provided URL.
              Get.to(() => ImageSlider(
                imageURl: (url ?? ''),// Pass the image link to the ImageSlider widget.
              ));
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

  // Returns a Text widget based on the provided buttonData, displaying the button title.
  Widget getButtonTextWidget(Buttons? buttonData) {
    // Determine the color to use when the button is not playing or selected
    final playColor = PreferenceUtil.getIfQurhomeisAcive()
        ? Color(CommonUtil()
            .getQurhomeGredientColor()) // Qurhome gradient color when Qurhome is active
        : Color(CommonUtil()
            .getMyPrimaryColor()); // Default primary color otherwise

    return Text(
      buttonData?.title ?? '',
      // Display the button title, or an empty string if null.

      style: TextStyle(
        color: (buttonData?.isPlaying.isTrue ?? false) ||
                (buttonData?.isSelected ?? false)
            ? Colors
                .white // Use white color if the button is playing or selected
            : playColor, // Otherwise, use the determined playColor

        fontSize: 14.0.sp, // Set the font size to 14 sp
      ),
    );
  }

  // Widget to display an image preview thumbnail
  Widget getImagePreviewThumbnail(String selectedImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          width: 1.sw, // Width is set to the screen width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  controller.stopTTS(); // Stop Text-to-Speech
                  controller.isSheelaScreenActive = false; // Deactivate Sheela screen
                  // Navigate to FullPhoto screen and handle the result
                  Get.to(FullPhoto(
                    url: "",
                    filePath: selectedImage,
                  ))?.then((value) {
                    controller.isSheelaScreenActive = true; // Reactivate Sheela screen after navigating back
                  });
                },
                child: Container(
                  // Container for the PhotoView
                  padding: EdgeInsets.only(
                    right: CommonUtil().isTablet! ? 200.sp : 60.sp,
                  ),
                  width: double.infinity, // Width takes the full width of the container
                  height: 200.h, // Height is set to 200 logical pixels
                  child: PhotoView(
                    // Widget to display the image with zooming capabilities
                    backgroundDecoration: BoxDecoration(color: Colors.transparent),
                    imageProvider: FileImage(File(selectedImage ?? '')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void goToAudioRecordScreen(){
    Get.to(AudioRecorder(
      arguments: AudioScreenArguments(
        fromVoice: false,
      ),
    ))?.then((results) {
      controller.isSheelaScreenActive = true;
      controller.updateTimer(enable: true);
      var audioPath = results[keyAudioFile];
      if (audioPath != null && audioPath != '') {
        controller.sheelaImagePreviewThumbnail(
            btnTitle: controller.btnTextLocal ?? '',
            selectedImagePath: audioPath);
      }
    });
  }

}
