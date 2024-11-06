import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/user/Tags.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

import '../main.dart';

class Taglist extends StatefulWidget {
  const Taglist(
      {Key? key, this.title, this.tags, this.onChecked, this.forMyProfile})
      : super(key: key);
  final String? title;
  final List<Tags>? tags;
  final bool? forMyProfile;
  final Function(List<Tags>?)? onChecked;
  @override
  // TODO: implement createState
  _TaglistState createState() => _TaglistState();
}

class _TaglistState extends State<Taglist> {
  List<CheckboxListTile> data = [];
  double tagTextSize =
      CommonUtil().isTablet! ? 20.0 : 16; //incrase the size of text in tablet

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: (widget?.forMyProfile ?? false)
                ? Text(
                    CommonConstants.tags,
                    style: TextStyle(fontSize: tagTextSize, color: Colors.grey),
                  )
                : SizedBox(),
          ),
          InkWell(
            onTap: () {},
            child: Wrap(
              alignment: WrapAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  children: widget.tags!
                      .map((e) =>
                          e.isChecked! ? _buildChip(e.name!) : Container())
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<CheckboxListTile> getlistWithCheckbox() {
    return widget.tags!
        .map((e) => CheckboxListTile(
              value: e.isChecked,
              checkColor: mAppThemeProvider.primaryColor,
              title: Text(e.name!,
                  style: TextStyle(
                    color: mAppThemeProvider.primaryColor,
                  )),
              onChanged: (val) {
                print(val);
                // whenAllIsChecked(val, e.name);
                e.isChecked = val;
                setState(() {
                  e.isChecked = val;
                });
                widget.onChecked!(widget.tags);
              },
              selected: e.isChecked!,
              activeColor: Colors.white,
            ))
        .toList();
  }

  Widget _buildChip(String label) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 5,
          bottom: 5), //set margin to adjust for both mobile and tablet
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: mAppThemeProvider.primaryColor),
        borderRadius: BorderRadius.circular(
          5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.transparent, // set backgrounf color transparent
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: mAppThemeProvider.primaryColor,
        ),
      ),
    );
  }
}
