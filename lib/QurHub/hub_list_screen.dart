import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/QurHub/Models/hub_list_response.dart';
import 'package:myfhb/QurHub/View/add_network_view.dart';
import 'package:myfhb/QurHub/hub_list_controller.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart';
import '../src/utils/screenutils/size_extensions.dart';

import 'add_device_screen.dart';

class HubListScreen extends StatefulWidget {
  const HubListScreen({Key key}) : super(key: key);

  @override
  _HubListScreenState createState() => _HubListScreenState();
}

class _HubListScreenState extends State<HubListScreen> {
  final controller = Get.put(HubListController());

  @override
  void initState() {
    controller.getHubList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
            onPressed: () {},
          ),
          title: Text('Connected Hub'),
          centerTitle: false,
          elevation: 0,
        ),
        body: Obx(() => controller.loadingData.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : controller.hubListResponse == null
                ? const Center(
                    child: Text(
                      'Please re-try after some time',
                    ),
                  )
                : Container(
                    child: controller.hubListResponse.isSuccess
                        ? controller.hubListResponse.result != null
                            ? Stack(children: [
                                SingleChildScrollView(
                                  child: listContent(
                                      controller.hubListResponse.result),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddDeviceScreen()),
                                        );
                                      },
                                      child: Card(
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor()),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                            'Add New Device',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ])
                            : pairNewDeviveBtn()
                        : pairNewDeviveBtn(),
                  )),
      );
  Widget pairNewDeviveBtn() {
    return Center(
      child: InkWell(
        onTap: () {
          unPairDialog('hub', '','');
          // try {
          //   Get.to(
          //     AddNetWorkView(),
          //   );
          // } catch (e) {
          //   print(e);
          // }
        },
        child: Card(
          color: Color(CommonUtil().getMyPrimaryColor()),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              'Pair New Hub',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget listContent(Result result) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/payment/failure.png',
                        height: 50,
                        width: 50,
                      ),
                      Text(result.hub.name),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Hub Id',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Text(
                              result.hub.serialNumber,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Paired On',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Text(
                              changeDateFormat(result.createdOn),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: (){
                      unPairDialog('hub','', result.hub.id);
                    },
                    child:  Card(
                      color: Color(CommonUtil().getMyPrimaryColor()),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Unpair',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            'Connected Devices',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(CommonUtil().getMyPrimaryColor()),
                fontSize: 18),
          ),
        ),
        ListView.builder(
            itemCount: result.userDeviceCollection.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/payment/failure.png',
                          height: 50,
                          width: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/payment/failure.png',
                          height: 50,
                          width: 50,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.userDeviceCollection[index].user
                                      .firstName ??
                                  '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Text(
                              'Device Id ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 12),
                            ),
                            Text(
                              'Connected ${changeDateFormat(result.userDeviceCollection[index].createdOn)}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 12),
                            )
                          ],
                        )),
                        InkWell(
                          onTap: (){
                            unPairDialog('device',result.userDeviceCollection[index].id,'')
                          },
                          child: Card(
                            color: Color(CommonUtil().getMyPrimaryColor()),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Unpair',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            })
      ],
    );
  }

  Future<Widget> unPairDialog(String type,String deviceId, String hubId)=> showDialog(context: context, builder: (BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child : Container(
          height: 178,
            child : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset('assets/payment/failure.png',height : 50, width : 50),
                    SizedBox(height: 15,),
                    Text(type=='hub'?'Do you want to unpair this Hub':'Do you want to unpair this device'),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children :[
                        InkWell(
                          onTap: (){
                            if(type=='hub'){
                              controller.unPairHub(hubId);
                              Navigator.pop(context);
                            }else{
                              controller.unPairDevice(deviceId);
                              Navigator.pop(context);
                            }
                          },
                          child: Card(
                            color: Colors.red,
                            child : Padding(
                              padding: const EdgeInsets.only(top :8.0,bottom: 8.0,left : 16.0,right : 16.0),
                              child: Text('Yes',style: TextStyle(color: Colors.white),),
                            )
                          ),
                        ),
                        SizedBox(width: 20,),
                        InkWell(
                          onTap: (){

                            Navigator.pop(context);

                          },
                          child: Card(
                              color: Colors.green,
                              child : Padding(
                                padding: const EdgeInsets.only(top :8.0,bottom: 8.0,left : 16.0,right : 16.0),
                                child: Text('No',style: TextStyle(color: Colors.white),),
                              )
                          ),
                        )
                      ]
                    )
                  ],
                ),
              ),
            )
        )
    );
  });

  showAlertDialog(BuildContext context,String type,String hubId) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        if(type=='hub'){
          controller.unPairHub(hubId);
          Navigator.pop(context);
        }else{

        }
      },
    );

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () { },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text(type=='hub'?'Do you want to unpair this Hub':'Do you want to unpair this device'),
      actions: [
        okButton,
        cancelButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
