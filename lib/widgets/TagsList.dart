import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/user/Tags.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class Taglist extends StatefulWidget {
  const Taglist({Key key, this.title, this.tags, this.onChecked,this.isClickable})
      : super(key: key);
  final String title;
  final List<Tags> tags;
  final bool isClickable;
  final Function(List<Tags>) onChecked;
  @override
    // TODO: implement createState
  _TaglistState createState() => _TaglistState();
}
class _TaglistState extends State<Taglist> {
  List<CheckboxListTile> data = List();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                child: Text(CommonConstants.tags,
                  style: TextStyle(fontSize: 14.0.sp,color: Colors.grey),

                ),
              ),
              InkWell(
                onTap: () {

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
                  ],
                ),
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
        print(val);
       // whenAllIsChecked(val, e.name);
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