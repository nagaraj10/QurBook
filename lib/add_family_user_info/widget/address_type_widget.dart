import 'package:flutter/material.dart';
import 'package:myfhb/add_family_user_info/models/address_result.dart';
import 'package:myfhb/add_family_user_info/viewmodel/doctor_personal_viewmodel.dart';

class AddressTypeWidget extends StatefulWidget {
  AddressResult addressResult;
  Function(AddressResult) onSelected;

  AddressTypeWidget({this.addressResult, this.onSelected});
  @override
  AddressTypeWidgetState createState() => AddressTypeWidgetState();
}

class AddressTypeWidgetState extends State<AddressTypeWidget> {
  DoctorPersonalViewModel doctorPersonalViewModel;

  String cityName = '';
  List<AddressResult> addressResultList;

  @override
  void initState() {
    super.initState();
    doctorPersonalViewModel = new DoctorPersonalViewModel();
    this.getAddressTypes();
  }

  Widget getDropDownAddress() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
      child: DropdownButton(
        isExpanded: true,
        items: addressResultList.map((item) {
          return new DropdownMenuItem(
            child: new Text(item.name),
            value: item,
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            widget.addressResult = newVal;
          });
          widget.onSelected(widget.addressResult);
        },
        value: widget.addressResult != null
            ? widget.addressResult
            : addressResultList[0],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (addressResultList != null && addressResultList.length > 0)
        ? getDropDownAddress()
        : checkIfAddressLength();
  }

  Widget checkIfAddressLength() {
    return new FutureBuilder<List<AddressResult>>(
      future: getAddressTypes(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return new Scaffold(
            body: Center(child: new CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          return snapshot.data != null ? getDropDownAddress() : reloadWidget();
        }
      },
    );
  }

  Widget reloadWidget() {
    return Container(child: Text('Error in Loading'));
  }

  Future<List<AddressResult>> getAddressTypes() async {
    var response = await doctorPersonalViewModel.getAddressTypeList();
    addressResultList = response;
    if (widget.addressResult != null) {
      widget.onSelected(addressResultList[0]);
    }

    return response;
  }
}
