import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myfhb/video_call/model/NotificationModel.dart';
import 'package:provider/provider.dart';
import '../../constants/router_variable.dart' as router;

import '../common/CommonUtil.dart';
import '../constants/variable_constant.dart';
import '../main.dart';
import '../video_call/model/CallArguments.dart';
import '../video_call/services/iOS_Notification_Handler.dart';
import '../video_call/utils/audiocall_provider.dart';
import 'notification_helper.dart';


class NotificationScreen extends StatefulWidget {
  NotificationModel? model;
  NotificationScreen(this.model);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
   Timer? _timer;
  @override
  void initState() {
    _timer = Timer(Duration(seconds: 30), () {
      Navigator.of(context).pop();
    });
    listenEvent(widget.model!.meeting_id.toString());
    super.initState();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFEFEFEF),
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    icon_splash_logo,
                    height: 80,
                    width: 80,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.model?.body??'',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    border: Border.all(color: Color(0xFFDBAD6A),width: 2)// Replace with your desired background color
                ),
                child: Center(
                  child: Text(
                    '${widget.model?.callArguments?.userName?[0]}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.model?.callArguments?.userName??'Unknown',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionItem('Decline', Icons.call_end, _onDecline),
                  Spacer(),
                  _buildActionItem('Accept', Icons.call, _onAccept),
                ],
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildActionItem(String label, IconData icon, Function() onPressed) => Column(
    children: [
      Ink(
        decoration: ShapeDecoration(
          color: label == 'Decline' ? Colors.red : Colors.green,
          shape: const CircleBorder(),
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );

  void _onDecline() {
    // Handle decline button press
    updateStatus(false, widget.model?.meeting_id.toString()??'');
    Navigator.pop(context);
  }

  void _onAccept() {
    // Handle accept button press
    updateStatus(true, widget.model?.meeting_id.toString()??'');
    if (widget.model!.callType!.toLowerCase() == 'audio') {
      Provider.of<AudioCallProvider>(Get.context!, listen: false)
          .enableAudioCall();
    } else if (widget.model!.callType!.toLowerCase() == 'video') {
      Provider.of<AudioCallProvider>(Get.context!, listen: false)
          .disableAudioCall();
    }
    Get.key.currentState!.pushNamed(
      router.rt_CallMain,
      arguments: widget.model?.callArguments,
    );
  }



   void listenEvent(String meetingId) {
     FirebaseFirestore.instance
         .collection('call_log')
         .doc(meetingId)
         .snapshots()
         .listen((DocumentSnapshot snapshot) {
       if (snapshot.exists) {
         String callStatus = snapshot['call_status'];

         if (callStatus == 'call_ended_by_user' ||
             callStatus == 'accept' ||
             callStatus == 'decline') {
           Navigator.pop(context);
         }
       }
     }, onError: (Object error) {
       print('Error: $error');
     });
   }

   @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}



