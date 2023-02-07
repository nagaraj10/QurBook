import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/chat/view/PDFViewerController.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/common/common_circular_indicator.dart';

class PDFView extends StatefulWidget {
  @override
  _PDFViewState createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  final controller = Get.find<PDFViewController>();

  @override
  void initState() {
    controller.loadingPDF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.data.title ?? "PDF Viewer",
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: GradientAppBar(),
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
                        Color(
                          CommonUtil().getMyPrimaryColor(),
                        ),
                      ),
                      backgroundColor: Colors.white.withOpacity(0.8),
                    ),
                  )
                : PDFViewer(
                    document: controller.document,
                  );
          },
        ),
      ),
    );
  }
}
