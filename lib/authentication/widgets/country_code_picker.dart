import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import '../constants/constants.dart' as constants;
import '../../common/CommonUtil.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class CountryCodePickerPage extends StatefulWidget {
  CountryCodePickerPage(
      {@required this.selectedDialogCountry, this.onValuePicked});

  Country selectedDialogCountry;
  var onValuePicked;

  @override
  _CountryCodePickerState createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePickerPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.black),
            child: CountryPickerDialog(
              titlePadding: EdgeInsets.all(8),
              searchCursorColor: Color(CommonUtil().getMyPrimaryColor()),
              searchInputDecoration: InputDecoration(
                  hintText: constants.strSearchCountry,
                  hintStyle: TextStyle(
                      fontSize: 15.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black)),
              isSearchable: true,
              title: Text(
                constants.strSearchCountryLabel,
                style: TextStyle(color: Colors.black, fontSize: 15.0.sp),
              ),
              onValuePicked: widget.onValuePicked,
              itemBuilder: _buildDialogItem,
              priorityList: [
                CountryPickerUtils.getCountryByIsoCode(CommonUtil.REGION_CODE),
              ],
            ),
          ),
        );
      },
      child: Container(child: _buildItem(widget.selectedDialogCountry)),
    );
  }

  Widget _buildItem(Country country) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 8.0.w),
          Text(
            "${'+'}(${country.phoneCode}) ",
            style: TextStyle(
                fontSize: 15.0.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
            size: 20.0.sp,
          ),
          SizedBox(width: 8.0.w),
        ],
      );

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 10.0.w),
          Text("${'+'}${country.phoneCode}",
              style: TextStyle(
                  fontSize: 15.0.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
          SizedBox(width: 10.0.w),
          Flexible(
              child: Text(country.name,
                  style: TextStyle(
                      fontSize: 15.0.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black)))
        ],
      );
}
