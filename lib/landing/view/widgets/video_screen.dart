import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import '../../../colors/fhb_colors.dart';
import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/fhb_parameters.dart';
import '../../model/qur_plan_dashboard_model.dart';
import '../../../src/ui/bot/widgets/youtube_player.dart';
import '../../../widgets/GradientAppBar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../src/utils/screenutils/size_extensions.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({
    @required this.videoList,
  });

  final List<HelperVideo> videoList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar(),
        backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
        elevation: 0,
        title: Text(strHowVideos),
        leading: IconWidget(
          icon: Icons.arrow_back_ios,
          colors: Colors.white,
          size: 24.0.sp,
          onTap: Get.back,
        ),
      ),
      backgroundColor: const Color(bgColorContainer),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: videoList?.length ?? 0,
        itemBuilder: (context, index) {
          if ((videoList[index]?.url ?? '').isNotEmpty) {
            final videoId = YoutubePlayer.convertUrlToId(videoList[index]?.url);
            return Container(
              constraints: BoxConstraints(
                minHeight: 0.15.sh,
                maxHeight: 0.2.sh,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 5.0.w,
                vertical: 5.0.h,
              ),
              child: Material(
                color: Colors.white,
                shadowColor: Theme.of(context).shadowColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    15.0.sp,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyYoutubePlayer(
                          videoId: videoId,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0.w,
                        vertical: 10.0.h,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                FadeInImage.assetNetwork(
                                  placeholder: qurHealthLogo,
                                  image: (videoList[index]?.thumbnail ?? '')
                                          .isNotEmpty
                                      ? videoList[index]?.thumbnail
                                      : YoutubePlayer.getThumbnail(
                                          videoId: videoId,
                                          quality: ThumbnailQuality.high,
                                        ),
                                ),
                                Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.black54,
                                  size: 60.0.sp,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20.0.w,
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              videoList[index].title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0.sp,
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

}
