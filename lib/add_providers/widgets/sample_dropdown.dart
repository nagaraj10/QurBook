import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/Media/media_result.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.mediaData, this.onChecked})
      : super(key: key);
  final String title;
  final List<MediaResult> mediaData;
  final Function(List<MediaResult>) onChecked;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<CheckboxListTile> data = new List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
          child: Column(
        children: [
          InkWell(
            onTap: () {
              updateData();
            },
            child: Wrap(
              children: [
                Wrap(
                  spacing: 6,
                  children: widget.mediaData
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
          ),
          Column(
            children: data.length > 1 ? [] : getlistWithCheckbox(),
          ),
        ],
      )),
    );
  }

  List<CheckboxListTile> getlistWithCheckbox() {
    return widget.mediaData
        .map((e) => CheckboxListTile(
              value: e.isChecked,
              checkColor: Color(CommonUtil().getMyPrimaryColor()),
              title: Text(e.name,
                  style: TextStyle(
                    color: Color(CommonUtil().getMyPrimaryColor()),
                  )),
              onChanged: (bool val) {
                print(val);
                whenAllIsChecked(val, e.name);
                e.isChecked = val;
                setState(() {
                  e.isChecked = val;
                });
                widget.onChecked(widget.mediaData);
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
      padding: EdgeInsets.all(10.0),
      margin: new EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: new BorderRadius.circular(
          5.0,
        ),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 20.0,
            offset: new Offset(0.0, 5.0),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  void whenAllIsChecked(bool val, String name) {
    if (name == 'ALL') {
      for (MediaResult mediaResult in widget.mediaData) {
        if (mediaResult.name == 'Prescription' ||
            mediaResult.name == 'Lab Report' ||
            mediaResult.name == 'Medical Report' ||
            mediaResult.name == 'Hospital Documents' ||
            mediaResult.healthRecordCategory?.categoryName == 'Devices') {
          mediaResult.isChecked = val;
        }
      }
    }
  }
}
