import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/text_widget.dart';
import '../../common/CommonUtil.dart';
import '../../constants/fhb_constants.dart';
import '../viewmodel/referafriend_vm.dart';
import '../model/referafriendrequest.dart';
import '../model/referafriendresponse.dart';
import '../../src/ui/loader_class.dart';
import 'package:provider/provider.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class InviteContactsScreen extends StatefulWidget {
  const InviteContactsScreen();

  @override
  _InviteContactsScreenState createState() => _InviteContactsScreenState();
}

class _InviteContactsScreenState extends State<InviteContactsScreen> {
  List<Contact> _contacts;
  List<Contact> _contactsSearched;
  List<Contact> selectedList = [];
  bool onSearch = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshContacts();
    });
  }

  FlutterToast toast = FlutterToast();

  Future<void> refreshContacts() async {
    final contacts = (await ContactsService.getContacts()).toList();
    contacts.forEach((element) {
      final phone = element.phones.toList();
      final List<Item> phoneNonRepeatList = [];
      for (var i = 0; i < phone.length; i++) {
        var repeat = false;
        for (var j = 0; j < phoneNonRepeatList.length; j++) {
          if (phone[i].value == phoneNonRepeatList[j].value) {
            repeat = true;
          }
        }
        if (!repeat) {
          phoneNonRepeatList.add(phone[i]);
          var conta = Contact(
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
          leading: IconWidget(
            icon: Icons.arrow_back_ios,
            colors: Colors.white,
            size: 20.0.sp,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            selectedList.isNotEmpty
                ? InkWell(
                    onTap: () {
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
                    if (value.trim().isNotEmpty) {
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
          : contactsValue.isNotEmpty
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
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: contacts?.length ?? 0,
      itemBuilder: (context, index) {
        final  contact = contacts?.elementAt(index);
        final  phone = contact.phones.toList();
        return phone == null || phone.isEmpty
            ? Container()
            : ListTile(
                selectedTileColor: Color(CommonUtil.bgColor),
                selected: selectedList.isEmpty
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
                leading: (contact.avatar != null && contact.avatar.isNotEmpty)
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
                  contact.displayName ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0.sp,
                  ),
                ),
                trailing: selectedList.isEmpty
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
        children: _items
            .map(
              (i) => Row(
                children: [
                  Text(
                    '${i.label} : ' ?? '',
                    style: TextStyle(
                      color: Colors.black26,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0.sp,
                    ),
                  ),
                  Text(
                    i.value ?? '',
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
    var contacts = List<Contacts>();
    selectedList.forEach((e) {
      e.phones.forEach((element) {
        if (element.value.isNotEmpty) {
          if (element.value.toString().contains('+')) {
            final mobileNo =
                '+${element.value.replaceAll(RegExp(r'[^\s\w]'), '').replaceAll(' ', '')}';
            contacts.add(Contacts(name: e.displayName, phoneNumber: mobileNo));
          } else {
            final mobileNo =
                '+91${element.value.replaceAll(RegExp(r'[^\s\w]'), '').replaceAll(' ', '')}';
            contacts.add(Contacts(name: e.displayName, phoneNumber: mobileNo));
          }
        }
      });
    });
    LoaderClass.showLoadingDialog(context);
    var addPatientContactRequest = ReferAFriendRequest(
        source:
            'qurbook', // since it's Qurbook application we have set "qurbook" as static
        contacts: contacts);
    await sendReferalRequest(addPatientContactRequest);
  }

  sendReferalRequest(ReferAFriendRequest friendRequest) {
    referAFriend(friendRequest).then((value) {
      final referalList = value?.result;
      LoaderClass.hideLoadingDialog(context);
      if (referalList?.length > 1) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    itemBuilder: (context, index) {
                      var trailingText = referalList[index].isExistingUser
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
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                              'assets/launcher/myfhb.png'),
                                        ),
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
                                              : referalList[index]?.name?.split(' ')[0][0],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        referalList[index]?.name
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
                                        referalList[index].phoneNumber,
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
                                          '$trailingText',
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
                                              '$trailingText',
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
                      children: [
                        OutlineButton(
                          onPressed: () {
                            selectedList.clear();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          borderSide: BorderSide(
                            color: Color(
                              CommonUtil().getMyPrimaryColor(),
                            ),
                          ),
                          child: Text(
                            'Ok'.toUpperCase(),
                            style: TextStyle(
                              color: Color(
                                CommonUtil().getMyPrimaryColor(),
                              ),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            });
      } else {
        //! Error msg need to be finalised here
        //FlutterToast().getToast('', Colors.red);
      }
    });
  }

  Future<ReferAFriendResponse> referAFriend(
      ReferAFriendRequest referAFriendRequest) async {
    final contactsPatientsViewModel =
        Provider.of<ReferAFriendViewModel>(context, listen: false);
    final response =
        await contactsPatientsViewModel.referFriendVMModel(referAFriendRequest);
    return response;
  }
}
