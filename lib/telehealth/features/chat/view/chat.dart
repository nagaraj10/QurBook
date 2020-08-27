import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/model/user/MyProfile.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:myfhb/telehealth/features/chat/model/GetMetaFileURLModel.dart';
import 'package:myfhb/telehealth/features/chat/view/full_photo.dart';
import 'package:myfhb/telehealth/features/chat/view/loading.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/GetMediaURLViewModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/CommonUtil.dart';

class Chat extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String lastDate;

  Chat(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
        @required this.peerName, @required this.lastDate})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatState();
}

class ChatState extends State<Chat> {
  var isSearchVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.15),
          child: _patientChatBar()),
      body: ChatScreen(
        peerId: widget.peerId,
        peerAvatar: widget.peerAvatar,
        peerName: widget.peerName,
        lastDate: widget.lastDate,
      ),
    );
  }

  Widget _patientChatBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
      flexibleSpace: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10),
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
                    width: 5,
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.67,
                      child: _patientDetailOrSearch(),
                    ),
                  ),

                  /*
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                  ),
                  GestureDetector(
                      onTap: () {
                        //area for video call button action
                      },
                      child: Icon(Icons.videocam, color: Colors.white)),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  /*GestureDetector(
                      onTap: () {
                        //area for call button action
                      },
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                      )),*/
                  moreOptionsPopup()
                  */
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: new TextStyle(color: Colors.grey[800]),
                  fillColor: Colors.white70),
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
                radius: 25,
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
                            fontFamily: 'Poppins', color: Colors.white)),
                    /*Text(
                      '#123232',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.white),
                    ),*/
                    Text(
                      widget.lastDate!=null?'Last visit date on '+DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(widget.lastDate))):'',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Colors.white),
                    ),
                    /*Text(
                      'Next appointment date Jul 15,2020',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Colors.white),
                    )*/
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

  Widget moreOptionsPopup() => PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      color: Colors.white,
      padding: EdgeInsets.only(left: 1, right: 2),
      itemBuilder: (context) => [
            PopupMenuItem(
                child: GestureDetector(
              child: Text('$popUpChoiceOne'),
              onTap: () {
                isSearchVisible = true;
                showSearch();
              },
            )),
            PopupMenuItem(
                child: GestureDetector(child: Text('$popUpChoiceTwo'))),
            PopupMenuItem(
                child: GestureDetector(child: Text('$popUpCHoiceThree')))
          ]);

  void showSearch() {
    setState(() {
      if (isSearchVisible) {
        _patientDetailOrSearch();
      }
    });
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String lastDate;

  ChatScreen(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName,@required this.lastDate})
      : super(key: key);

  @override
  State createState() => ChatScreenState(
      peerId: peerId, peerAvatar: peerAvatar, peerName: peerName,lastDate: lastDate);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName, @required this.lastDate});

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
  String patientId = '';
  String patientName = '';
  String patientPicUrl = '';

  final TextEditingController textEditingController = TextEditingController();
  var chatEnterMessageController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  List<String> recordIds = new List();
  GetMediaFileViewModel getMediaFileViewModel = GetMediaFileViewModel();
  FlutterToast toast = new FlutterToast();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(onFocusChange);
    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    readLocal();
    getPatientDetails();
  }

  getMediaURL(List<String> recordIds) {
    getMediaFileURL(recordIds).then((value) {
      if (value.status == 200 && value.success == true) {
        for (int i = 0; i < value.response.data.mediaMasterInfo.length; i++) {
          String fileType = value.response.data.mediaMasterInfo[i].fileType;
          String fileURL = value.response.data.mediaMasterInfo[i].fileContent;
          if ((fileType == '.jpg') || (fileType == '.png')) {
            onSendMessage(fileURL, 1);
          }
        }
      } else {
        toast.getToast('Unable to get file', Colors.red);
      }
    });
  }

  Future<GetMetaFileURLModel> getMediaFileURL(List<String> recordIds) async {
    GetMetaFileURLModel getMetaFileURLModel =
        await getMediaFileViewModel.getMediaMetaURL(recordIds, patientId);

    return getMetaFileURLModel;
  }

  Future<String> getPatientDetails() async {
    patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    MyProfile myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
    patientName = myProfile.response.data.generalInfo.qualifiedFullName != null
        ? myProfile.response.data.generalInfo.qualifiedFullName.firstName +
            myProfile.response.data.generalInfo.qualifiedFullName.lastName
        : '';
    patientPicUrl = getProfileURL();
  }

  String getProfileURL() {
    MyProfile myProfile = PreferenceUtil.getProfileData(Constants.KEY_PROFILE);
    String patientPicURL =
        myProfile.response.data.generalInfo.profilePicThumbnailURL;

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
    if (id == "") {
      groupChatId = '$peerId-$patientId';
    } else {
      if (id.hashCode <= peerId.hashCode) {
        groupChatId = '$id-$peerId';
      } else {
        groupChatId = '$peerId-$id';
      }
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
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) {
    print('patientId' + patientId);
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id == "" ? patientId : id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);

      addChatList(content);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  void addChatList(String content) {
    Firestore.instance
        .collection('chat_list')
        .document(patientId)
        .collection('user_list')
        .document(peerId)
        .setData({
      'nickname': peerName != null ? peerName : '',
      'photoUrl': peerAvatar != null ? peerAvatar : '',
      'id': peerId,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'lastMessage': content
    });

    Firestore.instance
        .collection('chat_list')
        .document(peerId)
        .collection('user_list')
        .document(patientId)
        .setData({
      'nickname': patientName != null ? patientName : '',
      'photoUrl': patientPicUrl != null ? patientPicUrl : '',
      'id': patientId,
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'lastMessage': content
    });
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == patientId) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == 0
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
                    child: Text(
                      document['content'],
                      style: TextStyle(
                          color: Color(CommonUtil().getMyPrimaryColor())),
                    ),
                  ),
                )
              /*? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: primaryColor),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: greyColor2,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )*/
              : document['type'] == 1
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
                            imageUrl: document['content'],
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
                                      FullPhoto(url: document['content'])));
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  // Sticker
                  : Container(
                      child: Image.asset(
                        'images/${document['content']}.gif',
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
                document['type'] == 0
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
                          child: Text(
                            document['content'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    /*Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )*/
                    : document['type'] == 1
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
                                  imageUrl: document['content'],
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
                                            url: document['content'])));
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : Container(
                            child: Image.asset(
                              'images/${document['content']}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
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

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == patientId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != patientId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Firestore.instance
          .collection('users')
          .document(id == "" ? patientId : id)
          .updateData({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
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
      onWillPop: onBackPress,
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
                height: 55,
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
                      onSubmitted: (value) =>
                          onSendMessage(textEditingController.text, 0),
                    ),
                    SizedBox(
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
                onPressed: () {},
                elevation: 2.0,
                fillColor: Colors.white,
                child: Icon(Icons.mic,
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

  /*Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }*/

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
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
      ),
    ))
        .then((results) {
      if (results.containsKey('metaId')) {
        var metaIds = results['metaId'];
        print(metaIds.toString());

        if (allowSelect) {
          recordIds = results['metaId'].cast<String>();
          getMediaURL(recordIds);
        }
        //print(recordIdCount);
        setState(() {});
        print(metaIds.toString());
      }
    });
  }
}
