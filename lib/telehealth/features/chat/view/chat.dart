import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/telehealth/features/chat/view/PdfViewURL.dart';
import 'package:myfhb/telehealth/features/chat/view/full_photo.dart';
import 'package:myfhb/telehealth/features/chat/view/loading.dart';
import 'package:myfhb/telehealth/features/chat/view/pdfiosViewer.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/CommonUtil.dart';

class Chat extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String lastDate;
  final String patientId;
  final String patientName;
  final String patientPicture;

  Chat(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName,
      @required this.lastDate,
      @required this.patientId,
      @required this.patientName,
      @required this.patientPicture})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatState();
}

class ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatScreen(
          peerId: widget.peerId,
          peerAvatar: widget.peerAvatar,
          peerName: widget.peerName,
          lastDate: widget.lastDate,
          patientId: widget.patientId,
          patientName: widget.patientName,
          patientPicture: widget.patientPicture),
    );
  }

  String getFormattedNewDateTime(int timeStamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    var formattedDate = DateFormat('MMM d, hh:mm a').format(date);
    return formattedDate;
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String lastDate;
  final String patientId;
  final String patientName;
  final String patientPicture;

  ChatScreen(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName,
      @required this.lastDate,
      @required this.patientId,
      @required this.patientName,
      @required this.patientPicture})
      : super(key: key);

  @override
  State createState() => ChatScreenState(
      peerId: peerId,
      peerAvatar: peerAvatar,
      peerName: peerName,
      lastDate: lastDate,
      patientId: patientId,
      patientName: patientName,
      patientPicUrl: patientPicture);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName,
      @required this.lastDate,
      @required this.patientId,
      @required this.patientName,
      @required this.patientPicUrl});

  String peerId;
  String peerAvatar;
  String peerName;
  String id;
  String lastDate;

  var listMessage;
  String groupChatId;
  SharedPreferences prefs;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  String patientId;
  String patientName;
  String patientPicUrl;

  final TextEditingController textEditingController = TextEditingController();
  var chatEnterMessageController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  var healthRecordList;
  List<String> recordIds = new List();
  FlutterToast toast = new FlutterToast();

  var isSearchVisible = false;

  List<String> wordsList = [];
  List<String> filteredWordsList = [];
  String textFieldValue = '';
  int commonIndex = 0;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(onFocusChange);
    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    patientId = widget.patientId;
    patientName = widget.patientName;
    patientPicUrl = widget.patientPicture;

    getPatientDetails();
  }

  getPatientDetails() async {
    if (patientId == null || patientId == '') {
      patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    }

    if (patientName == null || patientName == '') {
      MyProfileModel myProfile =
          PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
      patientName = myProfile.result != null
          ? myProfile.result.firstName + ' ' + myProfile.result.lastName
          : '';
    }

    if (patientPicUrl == null || patientPicUrl == '') {
      patientPicUrl = getProfileURL();
    }

    readLocal();
  }

  String getProfileURL() {
    MyProfileModel myProfile =
        PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
    String patientPicURL = myProfile.result.profilePicThumbnailUrl;

    return patientPicURL;
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    if (patientId.hashCode <= peerId.hashCode) {
      groupChatId = '$patientId-$peerId';
    } else {
      groupChatId = '$peerId-$patientId';
    }
    Firestore.instance
        .collection('users')
        .document(id == "" ? patientId : id)
        .updateData({'chattingWith': peerId});

    setState(() {});
  }

  Future getImage() async {
    PickedFile pickedfile;
    ImagePicker imagepicker = new ImagePicker();
    pickedfile = await imagepicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedfile.path);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: NOT_FILE_IMAGE);
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection(STR_MESSAGES)
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            STR_ID_FROM: id == "" ? patientId : id,
            STR_ID_TO: peerId,
            STR_TIME_STAMP: FieldValue.serverTimestamp(),
            STR_CONTENT: content,
            STR_TYPE: type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);

      addChatList(content);
    } else {
      Fluttertoast.showToast(msg: NOTHING_SEND);
    }
  }

  void addChatList(String content) {
    Firestore.instance
        .collection(STR_CHAT_LIST)
        .document(patientId)
        .collection(STR_USER_LIST)
        .document(peerId)
        .setData({
      STR_NICK_NAME: peerName != null ? peerName : '',
      STR_PHOTO_URL: peerAvatar != null ? peerAvatar : '',
      STR_ID: peerId,
      STR_CREATED_AT: FieldValue.serverTimestamp(),
      STR_LAST_MESSAGE: content
    });

    Firestore.instance
        .collection(STR_CHAT_LIST)
        .document(peerId)
        .collection(STR_USER_LIST)
        .document(patientId)
        .setData({
      STR_NICK_NAME: patientName != null ? patientName : '',
      STR_PHOTO_URL: patientPicUrl != null ? patientPicUrl : '',
      STR_ID: patientId,
      STR_CREATED_AT: FieldValue.serverTimestamp(),
      STR_LAST_MESSAGE: content
    });
  }

  openDownloadAlert(String fileUrl,BuildContext contxt,bool isPdf,String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'Are you sure want to download?',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                saveImageToGallery(fileUrl,contxt,isPdf,type);
                Navigator.pop(context);
              },
              child: Text('Download'),
            ),
          ],
        );
      },
    );
  }

  void saveImageToGallery(String fileUrl, BuildContext contxt,
      bool isPdfPresent, String fileType) async {
    //check the storage permission for both android and ios!
    //request gallery permission
    String albumName = 'myfhb';
    bool downloadStatus = false;
    PermissionStatus storagePermission = Platform.isAndroid
        ? await Permission.storage.status
        : await Permission.photos.status;
    if (storagePermission.isUndetermined || storagePermission.isRestricted) {
      Platform.isAndroid
          ? await Permission.storage.request()
          : await Permission.photos.request();
    }

    String _currentImage;
    Scaffold.of(contxt).showSnackBar(SnackBar(
      content: const Text(variable.strDownloadStart),
      backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
    ));

    if (isPdfPresent) {
      if (Platform.isIOS) {
        CommonUtil.downloadFile(fileUrl,fileType);
      } else {
        await ImageGallerySaver.saveFile(fileUrl).then((res) {
          setState(() {
            downloadStatus = true;
          });
        });
      }
    } else {
      _currentImage = fileUrl;
      try {
        CommonUtil.downloadFile(_currentImage,fileType).then((filePath) async {
          if (Platform.isAndroid) {
            Scaffold.of(contxt).showSnackBar(SnackBar(
              content: const Text(variable.strFileDownloaded),
              backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
              action: SnackBarAction(
                label: 'Open',
                onPressed: () async {
                  await OpenFile.open(filePath.path);
                },
              ),
            ));
          }
        });
      } catch (e) {
        print('$e exception thrown');
      }
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    List<TextSpan> textSpanList = [];

    if (document[STR_TYPE] == 0) {
      String tempData = document[STR_CONTENT];
      //setState(() {
      wordsList = tempData.split(',');
      filteredWordsList = wordsList;
      //});

      String word = document[STR_CONTENT];
      List<String> tempList =
          word.length > 1 && word.indexOf(textFieldValue) != -1
              ? word.split(textFieldValue)
              : [word, ''];
      int i = 0;
      tempList.forEach((item) {
        if (word.indexOf(textFieldValue) != -1 && i < tempList.length - 1) {
          commonIndex = index;
          textSpanList = [
            ...textSpanList,
            TextSpan(text: '${item}'),
            TextSpan(
              text: '${textFieldValue}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  background: Paint()..color = Colors.yellow),
            ),
          ];
        } else {
          //
          textSpanList = [...textSpanList, TextSpan(text: '${item}')];
        }
        i++;
      });
    }

    if (document[STR_ID_FROM] == patientId) {
      return Row(
        children: <Widget>[
          document[STR_TYPE] == 0
              // Text
              ? Card(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .6,
                    ),
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    /*child: Text(
                      document[STR_CONTENT],
                      style: TextStyle(
                          color: Color(CommonUtil().getMyPrimaryColor())),
                    ),*/
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: Color(CommonUtil().getMyPrimaryColor())),
                          children: textSpanList),
                    ),
                  ),
                )
              : document[STR_TYPE] == 1
                  // Image
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(themeColor),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: greyColor2,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document[STR_CONTENT],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FullPhoto(url: document[STR_CONTENT])));
                        },
                        onLongPress: () {
                          openDownloadAlert(document[STR_CONTENT],context,false,'.jpg');
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  // Pdf
                  : document[STR_TYPE] == 2
                      ? Card(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25))),
                          child: InkWell(
                            onTap: () {
                              goToPDFViewBasedonURL(document[STR_CONTENT]);
                            },
                            onLongPress: (){
                              openDownloadAlert(document[STR_CONTENT],context,false,'.pdf');
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * .6,
                              ),
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.picture_as_pdf,
                                    size: 14,
                                    color: Colors.black54,
                                  ),
                                  SizedBoxWidget(
                                    width: 5,
                                  ),
                                  Text(
                                    'Click to view PDF',
                                    style: TextStyle(
                                        color: Color(
                                            CommonUtil().getMyPrimaryColor())),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: Image.asset(
                            'images/${document[STR_CONTENT]}.gif',
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: peerAvatar,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document[STR_TYPE] == 0
                    ? Card(
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25))),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * .6,
                          ),
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Color(new CommonUtil().getMyPrimaryColor()),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.white),
                                children: textSpanList),
                          ),
                        ),
                      )
                    : document[STR_TYPE] == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          themeColor),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: greyColor2,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      'images/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document[STR_CONTENT],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullPhoto(
                                            url: document[STR_CONTENT])));
                              },
                              onLongPress: (){
                                openDownloadAlert(document[STR_CONTENT],context,false,'.jpg');
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : document[STR_TYPE] == 2
                            ? Card(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25))),
                                child: InkWell(
                                  onTap: () {
                                    goToPDFViewBasedonURL(
                                        document[STR_CONTENT]);
                                  },
                                  onLongPress: (){
                                    openDownloadAlert(document[STR_CONTENT],context,false,'.pdf');
                                  },
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              .6,
                                    ),
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.picture_as_pdf,
                                          size: 14,
                                          color: Colors.black54,
                                        ),
                                        SizedBoxWidget(
                                          width: 5,
                                        ),
                                        Text(
                                          'Click to view PDF',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                child: Image.asset(
                                  'images/${document[STR_CONTENT]}.gif',
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                                margin: EdgeInsets.only(
                                    bottom:
                                        isLastMessageRight(index) ? 20.0 : 10.0,
                                    right: 10.0),
                              ),
              ],
            ),
            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      getFormattedDateTime(
                          (document[STR_TIME_STAMP] as Timestamp)
                              .toDate()
                              .toString()),
                      style: TextStyle(
                          color: greyColor,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  goToPDFViewBasedonURL(String url) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          Platform.isIOS ? PDFiOSViewer(url: url) : PDFViewURL(url: url),
    ));
  }

  String getFormattedDateTime(String datetime) {
    DateTime dateTimeStamp = DateTime.parse(datetime);
    String formattedDate = DateFormat('MMM d, hh:mm a').format(dateTimeStamp);
    return formattedDate;
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1][STR_ID_FROM] == patientId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1][STR_ID_FROM] != patientId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  /*Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Firestore.instance
          .collection(STR_USERS)
          .document(id == "" ? patientId : id)
          .updateData({STR_CHATTING_WITH: null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }*/

  Widget _patientChatBar() {
    return AppBar(
      flexibleSpace: GradientAppBar(),
      automaticallyImplyLeading: false,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 2),
                  child: GestureDetector(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onTap: () {
                      //Add code for tapping back
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: _patientDetailOrSearch(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        /*IconWidget(
          icon: Icons.search,
          colors: Colors.white,
          size: 24,
          onTap: () {
            isSearchVisible = true;
            showSearch();
          },
        ),
        SizedBoxWidget(
          width: 15,
        ),*/
        IconWidget(
          icon: Icons.notifications,
          colors: Colors.white,
          size: 24,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationMain()),
            );
          },
        ),
        SizedBoxWidget(
          width: 5,
        ),
        moreOptionsPopup(),
      ],
    );
  }

  Widget moreOptionsPopup() => PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      color: Colors.white,
      padding: EdgeInsets.only(left: 1, right: 2),
      onSelected: (newValue) {
        if (newValue == 0) {
          isSearchVisible = true;
          showSearch();
        }
      },
      itemBuilder: (context) => [
            PopupMenuItem(
              value: 0,
              child: Text('$popUpChoiceOne'),
            ),
            /* PopupMenuItem(
            child: GestureDetector(child: Text('$popUpChoiceTwo'))),
        PopupMenuItem(
            child: GestureDetector(child: Text('$popUpCHoiceThree')))*/
          ]);

  void showSearch() {
    setState(() {
      if (isSearchVisible) {
        _patientDetailOrSearch();
      }
    });
  }

  void _onSearch(value) {
    setState(() {
      filteredWordsList =
          wordsList.where((item) => item.contains('$value')).toList();
      textFieldValue = value;
    });
  }

  Widget _patientDetailOrSearch() {
    var resultWidget = null;
    setState(() {
      if (isSearchVisible) {
        resultWidget = AnimatedSwitcher(
          duration: Duration(milliseconds: 10),
          child: Container(
            height: 45,
            child: TextField(
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      filteredWordsList = [];
                      wordsList = [];
                      textFieldValue = '';
                      isSearchVisible = false;
                      showSearch();
                    },
                    icon: Icon(Icons.clear, size: 20),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  fillColor: Colors.white70),
              onChanged: _onSearch,
            ),
          ),
        );
      } else {
        resultWidget = AnimatedSwitcher(
          duration: Duration(milliseconds: 10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(widget.peerAvatar),
                radius: 18,
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                  child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.peerName,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: variable.font_poppins,
                            fontSize: 16,
                            color: Colors.white)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.lastDate != null
                          ? LAST_RECEIVED + widget.lastDate
                          : '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: variable.font_poppins,
                          fontSize: 8,
                          color: Colors.white),
                    ),
                  ],
                ),
              ))
            ],
          ),
        );
      }
    });
    return resultWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _patientChatBar(),
      /*floatingActionButton: isSearchVisible?Padding(
        // padding: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.only(
          top: 250.0,
        ),
        child: Column(
          children: <Widget>[
            // SpeedDial
            new Theme(
              data: new ThemeData(
                accentColor: Colors.transparent,
              ),
              child: Container(
                height: MediaQuery.of(context).size.width * 0.1,
                width: MediaQuery.of(context).size.width * 0.1,
                child: new FloatingActionButton(
                  heroTag: null,
                  onPressed: () async {
                  },
                  child: Icon(Icons.arrow_upward),
                ),
              ),
            ),
            SizedBoxWidget(height: 5,),
            new Theme(
              data: new ThemeData(
                accentColor: Colors.transparent,
              ),
              child: Container(
                height: MediaQuery.of(context).size.width * 0.1,
                width: MediaQuery.of(context).size.width * 0.1,
                child: new FloatingActionButton(
                  heroTag: null,
                  onPressed: () async {
                    //listScrollController.animateTo(200*commonIndex,duration:Duration( ))
                  },
                  child: Icon(Icons.arrow_downward),
                ),
              ),
            ),
          ],
        ),
      ):Container(),*/
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.grey[300],
            child: Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),

                // Sticker
                (isShowSticker ? buildSticker() : Container()),

                // Input content
                buildInput(),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),

          // Loading
          buildLoading()
        ],
      ),
      //onWillPop: onBackPress,
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: Image.asset(
                  'images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: Image.asset(
                  'images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: Image.asset(
                  'images/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: Image.asset(
                  'images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: Image.asset(
                  'images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: Image.asset(
                  'images/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: Image.asset(
                  'images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: Image.asset(
                  'images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: Image.asset(
                  'images/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return IconTheme(
      data: IconThemeData(color: Colors.blue),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                height: 58,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      focusNode: focusNode,
                      onTap: () {
                        //isSearchVisible = false;
                        //_patientDetailOrSearch();
                      },
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: "$chatTextFieldHintText",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white70,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      /*onSubmitted: (value) =>*/
                    ),
                    SizedBoxWithChild(
                      width: 50,
                      height: 50,
                      child: FlatButton(
                          onPressed: () {
                            recordIds.clear();
                            FetchRecords(0, true, false, false, recordIds);
                          },
                          child: new Icon(
                            Icons.attach_file,
                            color: Color(CommonUtil().getMyPrimaryColor()),
                            size: 24,
                          )),
                    )
                  ],
                ),
              ),
            ),
            new Container(
              child: RawMaterialButton(
                onPressed: () {
                  onSendMessage(textEditingController.text, 0);
                },
                elevation: 2.0,
                fillColor: Colors.white,
                child: Icon(Icons.send,
                    size: 25.0, color: Color(CommonUtil().getMyPrimaryColor())),
                padding: EdgeInsets.all(12.0),
                shape: CircleBorder(),
              ),
              // child: new IconButton(
              //   icon: new Icon(Icons.send),
              //   onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: Color(new CommonUtil().getMyPrimaryColor())))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection(STR_MESSAGES)
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy(STR_TIME_STAMP, descending: true)
                  .limit(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  void FetchRecords(int position, bool allowSelect, bool isAudioSelect,
      bool isNotesSelect, List<String> mediaIds) async {
    print(allowSelect);
    print(isAudioSelect);
    print(isNotesSelect);
    print(position);

    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => MyRecords(
          categoryPosition: position,
          allowSelect: allowSelect,
          isAudioSelect: isAudioSelect,
          isNotesSelect: isNotesSelect,
          selectedMedias: mediaIds,
          isFromChat: true,
          isAssociateOrChat: true),
    ))
        .then((results) {
      if (results.containsKey(STR_META_ID)) {
        healthRecordList = results[STR_META_ID] as List;
        if (healthRecordList != null) {
          getMediaURL(healthRecordList);
        }
        setState(() {});
      }
    });
  }

  getMediaURL(List<HealthRecordCollection> healthRecordCollection) {
    for (int i = 0; i < healthRecordCollection.length; i++) {
      String fileType = healthRecordCollection[i].fileType;
      String fileURL = healthRecordCollection[i].healthRecordUrl;
      if ((fileType == STR_JPG) || (fileType == STR_PNG)) {
        onSendMessage(fileURL, 1);
      } else if ((fileType == STR_PDF)) {
        onSendMessage(fileURL, 2);
      }
    }
  }
}
