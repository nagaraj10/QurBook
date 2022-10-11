import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/regiment/service/regiment_service.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DexComWebScreen extends StatefulWidget {
  const DexComWebScreen({Key key}) : super(key: key);

  @override
  State<DexComWebScreen> createState() => _DexComWebScreenState();
}

class _DexComWebScreenState extends State<DexComWebScreen> {
  WebViewController _controller;
  String baseUrl='';
  String clientId='';
  String redirectUrl='';
  String state='';

  @override
  void initState() {
    // callAuthApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        initialUrl: 'https://sandbox-api.dexcom.com/v2/oauth2/login?client_id=k8y4DPCxKRs5AI3JGc1v7OhgvQH5oVQa&redirect_uri=https://dwtg3mk9sjz8epmqfo.vsolgmi.com/api/external-integration-api&response_type=code&scope=offline_access&state=Dexcom/e5ec4a8d-36a9-4ac9-b0a7-98d728d53dd4',
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (_) {
          readResponse();
        },
      ),
    );
  }

  void readResponse() async
  {
    if(_controller!=null){
      _controller.evaluateJavascript("document.documentElement.innerHTML").then((value) async {
        if(value.contains("success")&&value.contains("true")){
          Fluttertoast.showToast(msg: 'Authorized successfully');
        }
      });
      }
  }


    void callAuthApi() async {
      var regimentsData = await RegimentService.getExternalLinks();
      if(regimentsData.isSuccess){

      }
  }
}
