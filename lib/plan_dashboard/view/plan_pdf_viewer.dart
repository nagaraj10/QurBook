import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/responseModel.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class PlanPdfViewer extends StatelessWidget {
  const PlanPdfViewer({
    this.url,
    this.scaffoldKey,
  });

  final String url;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) => Builder(
        builder: (_) {
          final updatedData = CommonUtil().getFileNameAndUrl(url);
          if (updatedData?.isNotEmpty ?? false) {
            return FutureBuilder<PDFDocument>(
              future: PDFDocument.fromURL(updatedData.first),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CommonCircularIndicator();
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return Column(
                    children: [
                      Container(
                        color: Color(0xFF5C5C5C),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0.w,
                          vertical: 10.0.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                updatedData?.last ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 10.0.w,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    var common = CommonUtil();
                                    if (updatedData.isEmpty) {
                                      common.showStatusToUser(
                                        ResultFromResponse(false,
                                            'incorrect url, Failed to download'),
                                        scaffoldKey,
                                      );
                                    } else {
                                      await downloadFileForIos(updatedData);
                                    }
                                  },
                                  child: Image.asset(
                                    planDownload,
                                    width: 30.0.sp,
                                    height: 30.0.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PDFViewer(
                          document: snapshot.data,
                          showPicker: false,
                          showNavigation: false,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      );

  downloadFileForIos(List<String> updatedData) async {
    var response = await CommonUtil()
        .loadPdf(url: updatedData.first, fileName: updatedData.last);
    CommonUtil().showStatusToUser(response, scaffoldKey);
  }
}
