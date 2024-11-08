
import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import '../../common/CommonUtil.dart';
import '../../main.dart';
import '../../src/model/Media/media_result.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title, this.mediaData, this.onChecked})
      : super(key: key);
  final String? title;
  final List<MediaResult>? mediaData;
  final Function(List<MediaResult>?)? onChecked;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CheckboxListTile> data = [];

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
                  children: widget.mediaData!
                      .map(
                          (e) => e.isChecked! ? _buildChip(e.name!) : Container())
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
    return widget.mediaData!
        .map((e) => CheckboxListTile(
              value: e.isChecked,
              checkColor: mAppThemeProvider.primaryColor,
              title: Text(e.name!,
                  style: TextStyle(
                    color: mAppThemeProvider.primaryColor,
                  )),
              onChanged: (val) {
                print(val);
                whenAllIsChecked(val!, e.name!);
                e.isChecked = val;
                setState(() {
                  e.isChecked = val;
                });
                widget.onChecked!(widget.mediaData);
              },
              selected: e.isChecked!,
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
        border: Border.all(color: Theme.of(context).primaryColor),
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
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  void whenAllIsChecked(bool val, String name) {
    if (name == STR_ALL) {
      for (var mediaResult in widget.mediaData!) {
        if (mediaResult.name == STR_PRESCRIPTION ||
            mediaResult.name == STR_LABREPORT ||
            mediaResult.name == STR_MEDICALREPORT ||
            mediaResult.name == STR_HOSPITALDOCUMENT ||
            mediaResult.name == STR_PROVIDERDOCUMENTS ||
            mediaResult.healthRecordCategory?.categoryName == STR_DEVICES) {
          mediaResult.isChecked = val;
        }
      }
    }
  }
}
