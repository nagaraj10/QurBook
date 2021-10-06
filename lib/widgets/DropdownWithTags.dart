import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/user/Tags.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class DropdownWithTags extends StatefulWidget{
  const DropdownWithTags({Key key, this.title, this.tags, this.onChecked,this.isClickable})
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 5),
                child: Text(CommonConstants.tags,
                  style: TextStyle(fontSize: 14.0.sp,color: Colors.grey),

                ),
              ),
              Padding(
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
                    IconButton(
                        icon: Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          updateData();
                        })
                  ],
                ),
              ),),
              Column(
                children: data.length > 1 ? [] : getlistWithCheckbox(),
              ),
            ],
          )),
    );
  }

  List<CheckboxListTile> getlistWithCheckbox() {
    return widget.tags
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
        widget.onChecked(widget.tags);
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

}

