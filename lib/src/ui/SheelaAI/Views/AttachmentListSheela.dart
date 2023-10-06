import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/Common/GradientAppBarQurhome.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/SheelaResponse.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFModel.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFView.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFViewerController.dart';
import 'package:myfhb/telehealth/features/chat/view/full_photo.dart';
import 'package:myfhb/ticket_support/model/ticket_list_model/attachments.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'audio_player_screen.dart';

class AttachmentListSheela extends StatefulWidget {
  const AttachmentListSheela({Key? key, required this.chatAttachments})
      : super(key: key);

  final List<ChatAttachments>? chatAttachments;

  @override
  State<AttachmentListSheela> createState() => _AttachmentListSheelaState();
}

class _AttachmentListSheelaState extends State<AttachmentListSheela> {
  List<ChatAttachments>? _chatAttachments;
  var pdfViewController;

  @override
  void initState() {
    super.initState();
    pdfViewController =
    CommonUtil().onInitPDFViewController();
    _chatAttachments = widget.chatAttachments;

    PreferenceUtil.saveIfSheelaAttachmentPreviewisActive(
      qurhomeStatus: true,
    );
  }

  @override
  void dispose() {
    PreferenceUtil.saveIfSheelaAttachmentPreviewisActive(
      qurhomeStatus: false,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: (PreferenceUtil.getIfQurhomeisAcive())
            ? GradientAppBarQurhome()
            : GradientAppBar(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          ATTACH_TITLE,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0.sp,
          ),
        ),
      ),
      body: listView(),
      /*floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          width: 180.w,
          child: OutlinedButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              strBack,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(CommonUtil().getMyPrimaryColor())),
            ),
            style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                side:
                    BorderSide(color: Color(CommonUtil().getMyPrimaryColor()))),
          ),
        )*/
    );
  }

  Widget listView() {
    return Container(
      decoration: BoxDecoration(color: Color(bgColorContainer)),
      child: Column(
        children: [
          Expanded(
              child: ((_chatAttachments?.length ?? 0) > 0)
                  ? ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(_chatAttachments![index]),
                      itemCount: _chatAttachments?.length,
                    )
                  : Container(
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            strNoAttachments,
                            style: TextStyle(
                                fontSize: 16.0.sp, color: Colors.grey[800]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                    )),
        ],
      ),
    );
  }

  Widget buildItem(ChatAttachments listItem) {
    return InkWell(
      onTap: () {
        goToPreviewScreens(listItem);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (listItem.documentId ?? '') +
                          CommonUtil().getExtensionSheelaPreview(
                              listItem.messages?.type ?? 0),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      listItem.deliveredDateTime ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  goToPreviewScreens(ChatAttachments attachments) {
    String title = (attachments.documentId ?? '') +
        CommonUtil().getExtensionSheelaPreview(attachments.messages?.type ?? 0);
    switch (attachments.messages?.type ?? 0) {
      case 0:
        return;
      case 1:
        Get.to(FullPhoto(
          url: attachments.messages?.content ?? '',
          titleSheelaPreview: title,
          chatMessageId: attachments.messages?.chatMessageId ?? '',
        ));
        return;
      case 2:
        goToPDFViewBasedonURL(attachments.messages?.content ?? '', title,
            attachments.messages?.chatMessageId ?? '');
        return;
      case 3:
        Get.to(AudioPlayerScreen(
          audioUrl: (attachments.messages?.content ?? ''),
          chatMessageId: (attachments.messages?.chatMessageId ?? ''),
          titleAppBar: (title ?? ''),
        ));
        return;
      default:
        return;
    }
  }

  goToPDFViewBasedonURL(String? url, String? title, String? chatMessageId) {
    try {
      final data = OpenPDF(type: PDFLocation.URL, path: url);
      pdfViewController.data = data;
      Get.to(() => PDFView(
          isFromSheelaPreview: true,
          sheelaPreviewTitle: title,
          chatMessageId: chatMessageId));
    } catch (e) {}
  }
}
