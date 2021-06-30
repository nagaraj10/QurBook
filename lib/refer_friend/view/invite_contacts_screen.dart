import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/refer_friend/viewmodel/referafriend_vm.dart';
import 'package:myfhb/refer_friend/model/referafriendrequest.dart';
import 'package:myfhb/refer_friend/model/referafriendresponse.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class InviteContactsScreen extends StatefulWidget {
  InviteContactsScreen();

  @override
  _InviteContactsScreenState createState() => _InviteContactsScreenState();
}

class _InviteContactsScreenState extends State<InviteContactsScreen> {
  List<Contact> _contacts;
  List<Contact> _contactsSearched;
  List<Contact> selectedList = List();
  bool onSearch = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshContacts();
    });
  }

  FlutterToast toast = new FlutterToast();

  Future<void> refreshContacts() async {
    var contacts = (await ContactsService.getContacts()).toList();
    contacts.forEach((element) {
      List<Item> phone = element.phones.toList();
      List<Item> phoneNonRepeatList = List();
      for (var i = 0; i < phone.length; i++) {
        bool repeat = false;
        for (var j = 0; j < phoneNonRepeatList.length; j++) {
          if (phone[i].value == phoneNonRepeatList[j].value) {
            repeat = true;
          }
        }
        if (!repeat) {
          phoneNonRepeatList.add(phone[i]);
          Contact conta = Contact(
              phones: [phone[i]],
              displayName: element.displayName,
              avatar: element.avatar,
              familyName: element.familyName,
              givenName: element.givenName);
          newContacts.add(conta);
        } else {
          phone.remove(phone[i]);
        }
      }
    });
    setState(() {
      _contacts = newContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: 20.0.sp,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            selectedList.length != 0
                ? InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      sendInviteToFriends();
                    },
                    child: Container(
                      padding: EdgeInsets.all(
                        8.0.sp,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        strSendInvite,
                        style: TextStyle(
                          fontSize: 16.0.sp,
                        ),
                      ),
                    ),
                  )
                : SizedBox()
          ],
          title: TextWidget(
            text: strContactsLabel,
            colors: Colors.white,
            overflow: TextOverflow.visible,
            fontWeight: FontWeight.w600,
            fontsize: 18.0.sp,
            softwrap: true,
          ),
        ),
        body: Column(
          children: [
            searchWidget(),
            inviteContactsBodyView(onSearch ? _contactsSearched : _contacts)
          ],
        ));
  }

  Widget searchWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: 20.0.w,
        right: 20.0.w,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 10.0.h,
          right: 10.0.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 40.0.h,
                ),
                decoration: BoxDecoration(
                  color: Color(CommonUtil.bgColor),
                  borderRadius: BorderRadius.circular(
                    40.0.sp,
                  ),
                ),
                child: TextFormField(
                  onChanged: (value) {
                    if (value.trim().length > 0) {
                      setState(() {
                        onSearch = true;
                        _contactsSearched = _contacts
                            .where((element) => element.displayName
                                .trim()
                                .toLowerCase()
                                .contains(value.trim().toLowerCase()))
                            .toList();
                      });
                    } else {
                      setState(() {
                        onSearch = false;
                        searchController.clear();
                        _contactsSearched = null;
                      });
                    }
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(
                      2.0.sp,
                    ),
                    hintText: strSearchContacts,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black54,
                      size: 24.0.sp,
                    ),
                    suffixIcon: onSearch
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                onSearch = false;
                                searchController.clear();
                              });
                            },
                            child: Icon(
                              Icons.clear,
                              size: 24.0.sp,
                              color: Colors.black54,
                            ),
                          )
                        : Container(
                            width: 0.w,
                            height: 0.h,
                          ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.black45,
                      fontSize: 14.0.sp,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.0.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inviteContactsBodyView(List<Contact> contactsValue) {
    return Expanded(
      child: contactsValue == null
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(CommonUtil().getMyPrimaryColor()),
              ),
            )
          : contactsValue.length != 0
              ? listTile(contactsValue)
              : Center(
                  child: Container(
                    child: Text(
                      onSearch ? strNoContactsSearchlbl : strNoContactsLabel,
                      style: TextStyle(
                        fontSize: 16.0.sp,
                      ),
                    ),
                  ),
                ),
    );
  }

  List<Contact> newContacts = [];

  Widget listTile(List<Contact> contacts) {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: 10.0.h,
      ),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: contacts?.length ?? 0,
      itemBuilder: (context, index) {
        Contact contact = contacts?.elementAt(index);
        List<Item> phone = contact.phones.toList();
        return phone == null || phone.length == 0
            ? Container()
            : ListTile(
                selectedTileColor: Color(CommonUtil.bgColor),
                selected: selectedList.length == 0
                    ? false
                    : selectedList.contains(contact)
                        ? true
                        : false,
                onTap: () {
                  if (selectedList.contains(contact)) {
                    setState(() {
                      selectedList.remove(contact);
                    });
                  } else {
                    setState(() {
                      selectedList.add(contact);
                    });
                  }
                },
                leading: (contact.avatar != null && contact.avatar.length > 0)
                    ? CircleAvatar(
                        backgroundColor: Color(0xFFf7f6f5),
                        backgroundImage: MemoryImage(contact.avatar))
                    : CircleAvatar(
                        backgroundColor: Color(0xFFf7f6f5),
                        child: Text(
                          contact.initials(),
                          style: TextStyle(
                              fontSize: 16.0.sp,
                              color: Color(CommonUtil().getMyPrimaryColor())),
                        ),
                      ),
                title: Text(
                  contact.displayName ?? "",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0.sp,
                  ),
                ),
                trailing: selectedList.length == 0
                    ? Container(
                        height: 0,
                        width: 0,
                      )
                    : selectedList.contains(contact)
                        ? Icon(
                            Icons.check,
                            size: 24.0.sp,
                            color: Color(CommonUtil().getMyPrimaryColor()),
                          )
                        : Container(
                            height: 0.h,
                            width: 0.w,
                          ),
                subtitle: itemsTile(contact.phones),
              );
      },
    );
  }

  itemsTile(Iterable<Item> _items) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _items
            .map(
              (i) => Row(
                children: [
                  Text(
                    "${i.label} : " ?? "",
                    style: TextStyle(
                      color: Colors.black26,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0.sp,
                    ),
                  ),
                  Text(
                    i.value ?? "",
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0.sp,
                    ),
                  ),
                ],
              ),
            )
            .toList());
  }

  sendInviteToFriends() async {
    List<Contacts> contacts = List();
    selectedList.forEach((e) {
      e.phones.forEach((element) {
        if (element.value.isNotEmpty) {
          if (element.value.toString().contains('+')) {
            String mobileNo =
                '+${element.value.replaceAll(RegExp(r'[^\s\w]'), '').replaceAll(' ', '')}';
            contacts.add(Contacts(name: e.displayName, phoneNumber: mobileNo));
          } else {
            String mobileNo =
                '+91${element.value.replaceAll(RegExp(r'[^\s\w]'), '').replaceAll(' ', '')}';
            contacts.add(Contacts(name: e.displayName, phoneNumber: mobileNo));
          }
        }
      });
    });
    LoaderClass.showLoadingDialog(context);
    ReferAFriendRequest addPatientContactRequest = ReferAFriendRequest(
        source:
            'qurbook', // since it's Qurbook application we have set "qurbook" as static
        contacts: contacts);
    await sendReferalRequest(addPatientContactRequest);
  }

  sendReferalRequest(ReferAFriendRequest friendRequest) {
    referAFriend(friendRequest).then((value) {
      List<Result> referalList = value?.result ?? [];
      if (value?.isSuccess && referalList?.length > 0) {
        LoaderClass.hideLoadingDialog(context);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Invite Summary',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0.sp,
                      ),
                    ),
                  ],
                ),
                content: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: 0.75.sw, // Change as per your requirement
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: referalList?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      String trailingText = referalList[index].isExistingUser
                          ? 'User Exists'
                          : 'Invite Sent';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                referalList[index].isExistingUser
                                    ? CircleAvatar(
                                        radius: 15,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                              'assets/launcher/myfhb.png'),
                                        ),
                                        backgroundColor: Colors.transparent,
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Color(0xFFf7f6f5),
                                        radius: 15,
                                        child: Text(
                                          referalList[index]
                                                      ?.name
                                                      .split(' ')
                                                      .length >
                                                  1
                                              ? '${referalList[index]?.name?.split(' ')[0][0]}${referalList[index]?.name?.split(' ')[1][0]}'
                                              : '${referalList[index]?.name?.split(' ')[0][0]}',
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                  width: 5.0.w,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ('${referalList[index]?.name}')
                                            .capitalizeFirstofEach,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      Text(
                                        '${referalList[index].phoneNumber}',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black45,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0.w,
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    // color: referalList[index].isExistingUser
                                    //     ? Colors.yellow[600]
                                    //     : Colors.green.withOpacity(0.7),
                                    color: Colors.white,
                                  ),
                                  child: referalList[index].isExistingUser
                                      ? Text(
                                          '${trailingText}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${trailingText}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.green,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.0.w,
                                            ),
                                            SvgPicture.asset(
                                              sendIcon,
                                              width: 15.0.sp,
                                              height: 15.0.sp,
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // Divider(
                            //   height: 1,
                            //   // indent: 5,
                            //   // endIndent: 5,
                            //   color: Colors.black26,
                            // ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlineButton(
                          child: Text(
                            'Ok'.toUpperCase(),
                            style: TextStyle(
                              color: Color(
                                CommonUtil().getMyPrimaryColor(),
                              ),
                              fontSize: 13,
                            ),
                          ),
                          onPressed: () {
                            selectedList.clear();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          borderSide: BorderSide(
                            color: Color(
                              CommonUtil().getMyPrimaryColor(),
                            ),
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            });
      } else {
        FlutterToast().getToast(strInviteErrorMsg, Colors.red);
        Future.delayed(Duration(seconds: 2), () {
          LoaderClass.hideLoadingDialog(context);
          Navigator.pop(context);
        });
      }
    });
  }

  Future<ReferAFriendResponse> referAFriend(
      ReferAFriendRequest referAFriendRequest) async {
    ReferAFriendViewModel contactsPatientsViewModel =
        Provider.of<ReferAFriendViewModel>(context, listen: false);
    ReferAFriendResponse response =
        await contactsPatientsViewModel.referFriendVMModel(referAFriendRequest);
    return response;
  }
}
