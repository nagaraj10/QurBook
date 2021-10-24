import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/user/Tags.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class DropdownWithTags extends StatefulWidget {
  const DropdownWithTags(
      {Key key, this.title, this.tags, this.onChecked, this.isClickable})
      : super(key: key);
  final String title;
  final List<Tags> tags;
  final bool isClickable;
  final Function(List<Tags>) onChecked;

  @override
  _DropdownWithTagsState createState() => _DropdownWithTagsState();
}

class _DropdownWithTagsState extends State<DropdownWithTags> {
  List<CheckboxListTile> data = List();
  final nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();

  List<Tags> _foundUsers=[];
  @override
  void initState() {
    _foundUsers = widget.tags;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CommonConstants.tags,
            style: TextStyle(fontSize: 14.0.sp, color: Colors.grey),
          ),
          Row(
            children: <Widget>[
              _showFirstNameTextField(),
            ],
          ),
          /* Padding(
                padding: EdgeInsets.only(left: 20),
                child: InkWell(
                onTap: () {
                  if(widget.isClickable)
                    updateData();
                },
                child: Wrap(
                  children: [
                    Wrap(
                      spacing: 6,
                      children: widget.tags
                          .map(
                              (e) => e.isChecked ? _buildChip(e.name) : Container())
                          .toList(),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Visibility(visible: widget.isClickable?true:false,child: IconButton(
                        icon: Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          if(widget.isClickable)
                            updateData();
                        }),),

                  ],
                ),
              ),),*/
          Column(
            children: data.length > 1 ? [] : getlistWithCheckbox(),
          ),
        ],
      )),
    );
  }

  List<CheckboxListTile> getlistWithCheckbox() {
    return _foundUsers
        .map((e) => CheckboxListTile(
              value: e.isChecked,
              checkColor: Color(CommonUtil().getMyPrimaryColor()),
              title: Text(e.name,
                  style: TextStyle(
                    color: Color(CommonUtil().getMyPrimaryColor()),
                  )),
              onChanged: (val) {
                e.isChecked = val;
                setState(() {
                  e.isChecked = val;
                });
                widget.onChecked(_foundUsers);
              },
              selected: e.isChecked,
              activeColor: Colors.white,
            ))
        .toList();
  }

  updateData() {
    if (data.length > 1) {
      data = [];
    } else {
      data = getlistWithCheckbox();
    }
    setState(() {});
  }

  Widget _buildChip(String label) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(CommonUtil().getMyPrimaryColor())),
        borderRadius: BorderRadius.circular(
          5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Color(CommonUtil().getMyPrimaryColor()),
        ),
      ),
    );
  }

  Widget _showFirstNameTextField() {
    return Expanded(
        child: TextField(
      cursorColor: Color(CommonUtil().getMyPrimaryColor()),
      controller: nameController,
      keyboardType: TextInputType.text,
      focusNode: nameFocus,
      textInputAction: TextInputAction.done,
      onSubmitted: (term) {},
      onChanged: (value) {
        _runFilter(value);
      },
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.0.sp,
          color: ColorUtils.blackcolor),
      decoration: InputDecoration(
        labelText: CommonConstants.search,
        hintText: CommonConstants.search,
        labelStyle: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.myFamilyGreyColor),
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          color: ColorUtils.myFamilyGreyColor,
          fontWeight: FontWeight.w400,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorUtils.myFamilyGreyColor)),
      ),
    ));
  }
  void _runFilter(String enteredKeyword) {
    List<Tags> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = widget.tags;
    } else {
      results = widget.tags
          .where((user) =>
          user.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {_foundUsers = results;
    });
    widget.onChecked(_foundUsers);
  }
}
