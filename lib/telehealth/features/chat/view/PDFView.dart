import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/Common/GradientAppBarQurhome.dart';
import 'package:myfhb/chat_socket/service/ChatSocketService.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFViewerController.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';

import '../../../../main.dart';

class PDFView extends StatefulWidget {
  const PDFView(
      {Key? key,
      this.isFromSheelaPreview = false,
      this.sheelaPreviewTitle,
      this.chatMessageId})
      : super(key: key);

  final bool isFromSheelaPreview;
  final String? sheelaPreviewTitle;
  final String? chatMessageId;

  @override
  _PDFViewState createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  final controller = Get.find<PDFViewController>();

  ChatSocketService _chatSocketService = ChatSocketService();

  @override
  void initState() {
    controller.loadingPDF();
    super.initState();
    if (widget.chatMessageId != null && widget.chatMessageId != '') {
      callChatunreadMessageApi();
    }
  }

  callChatunreadMessageApi() {
    _chatSocketService.getUnreadChatWithMsgId(widget.chatMessageId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFromSheelaPreview
              ? (widget.sheelaPreviewTitle ?? '')
              : controller.data.title ?? "PDF Viewer",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0.sp,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: widget.isFromSheelaPreview ? true : false,
        flexibleSpace: (PreferenceUtil.getIfQurhomeisAcive())
            ? GradientAppBarQurhome()
            : GradientAppBar(),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Obx(
          () {
            return controller.isLoading.value
                ? Container(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        mAppThemeProvider.primaryColor,
                      ),
                      backgroundColor: Colors.white.withOpacity(0.8),
                    ),
                  )
                : PDFViewer(
                    document: controller.document!,
                  );
          },
        ),
      ),
    );
  }
}
