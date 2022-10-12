import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/regiment/service/regiment_service.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DexComWebScreen extends StatefulWidget {
  DexComWebScreen({Key key,this.baseUrl, this.clientId,  this.redirectUrl,  this.state}) : super(key: key);
  String baseUrl='';
  String clientId='';
  String redirectUrl='';
  String state='';
  @override
  State<DexComWebScreen> createState() => _DexComWebScreenState();
}

class _DexComWebScreenState extends State<DexComWebScreen> {
  WebViewController _controller;


  @override
  void initState() {
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
        initialUrl: '${widget.baseUrl}/v2/oauth2/login?client_id=${widget.clientId}&redirect_uri=${widget.redirectUrl}&response_type=code&scope=offline_access&state=${widget.state}',
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

        if(value.contains("isSuccess")&&value.contains("true")){
          Fluttertoast.showToast(msg: 'Authorized successfully');
          Future.delayed(Duration(milliseconds: 500),(){
            Navigator.pop(context);
          });
        }
      });
      }
  }

}
