import 'package:flutter/material.dart';
import '../models/address_result.dart';
import '../viewmodel/doctor_personal_viewmodel.dart';
import '../../common/errors_widget.dart';

class AddressTypeWidget extends StatefulWidget {
  AddressResult addressResult;
  List<AddressResult> addressList;
  Function(AddressResult, List<AddressResult>) onSelected;

  AddressTypeWidget({this.addressResult, this.onSelected, this.addressList});
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
    doctorPersonalViewModel = DoctorPersonalViewModel();
    if (widget.addressList != null && widget.addressList.isNotEmpty) {
      addressResultList = widget.addressList;
    }
    getAddressTypes();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.addressList != null && widget.addressList.isNotEmpty)
        ? getDropDownAddress()
        : checkIfAddressLength();
  }

  Widget getDropDownAddress() {
    var itemSelected = widget.addressResult.id != null
        ? widget.addressResult
        : addressResultList[0];
    for (final res in addressResultList) {
      if (res.id == widget.addressResult.id) {
        itemSelected = res;
      }
    }
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 4),
      child: DropdownButton(
        value: itemSelected,
        isExpanded: true,
        items: addressResultList.map((item) {
          return DropdownMenuItem(
            child: Text(item.name),
            value: item,
          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            widget.addressResult = newVal;
          });
          widget.onSelected(widget.addressResult, widget.addressList);
        },
        /* value: widget.addressResult != null
            ? widget.addressResult
            : addressResultList[0], */
      ),
    );
  }

  Widget checkIfAddressLength() {
    return FutureBuilder<List<AddressResult>>(
      future: getAddressTypes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return ErrorsWidget();
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
    final response = await doctorPersonalViewModel.getAddressTypeList();
    addressResultList = response;

    if (widget.addressResult != null) {
      widget.onSelected(widget.addressResult, addressResultList);
    } else {
      widget.onSelected(addressResultList[0], addressResultList);
    }

    return addressResultList;
  }
}
