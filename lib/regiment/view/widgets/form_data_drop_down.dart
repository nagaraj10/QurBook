import 'package:flutter/material.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../../common/CommonUtil.dart';
import '../../models/field_response_model.dart';
import '../../../constants/fhb_constants.dart' as Constants;

class FormDataDropDown extends StatefulWidget {
  const FormDataDropDown(
      {required this.fieldData,
      required this.updateValue,
      required this.canEdit,
      this.isFromQurHomeSymptom = false,
      this.vitalsData,
      required this.isChanged});

  final FieldModel fieldData;
  final Function(FieldModel updatedfieldData) updateValue;
  final bool canEdit;
  final bool isFromQurHomeSymptom;
  final VitalsData? vitalsData;
  final Function(bool isChanged) isChanged;

  @override
  _FormDataDropDownState createState() => _FormDataDropDownState();
}

class _FormDataDropDownState extends State<FormDataDropDown> {
  List<DropdownMenuItem<dynamic>> comboItems = [];
  var comboValue;

  @override
  void initState() {
    super.initState();
    if (widget.vitalsData?.value != null && widget.vitalsData?.value != "") {
      setValuesInMap(widget.vitalsData?.value);
    }
    loadComboItems();
  }

  loadComboItems() {
    final comboItemsList = (widget.fieldData.fdata ?? '')?.split('|');
    if (comboItemsList.isNotEmpty && comboItemsList.length.isEven) {
      comboValue = getComboValue(comboItemsList);
      comboItems.clear();
      for (var i = 0; i < comboItemsList.length; i++) {
        comboItems.add(
          DropdownMenuItem(
            value: comboItemsList[i],
            child: Text(
              comboItemsList[i + 1],
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0.sp,
              ),
            ),
          ),
        );
        i++;
      }
    }
    comboItems.isNotEmpty ? comboItems[0].value : null;
    print(comboItems);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          CommonUtil().showDescriptionTextForm(widget.fieldData),
          style: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w600,
            color: widget.isFromQurHomeSymptom
                ? Color(CommonUtil().getQurhomePrimaryColor())
                : Color(CommonUtil().getMyPrimaryColor()),
          ),
        ),
        SizedBox(
          height: 10.0.h,
        ),
        DropdownButton<dynamic>(
          style: TextStyle(
            fontSize: 16.0.sp,
          ),
          hint: Text(
            /*(widget.fieldData?.title ?? '').isNotEmpty
                ? '${Constants.select} ${widget.fieldData?.title}'
                : '',*/
            (widget.fieldData.title ?? '').isNotEmpty
                ? '${Constants.select}'
                : '',
            style: TextStyle(
              fontSize: 14.0.sp,
            ),
          ),
          isExpanded: true,
          //TODO: Need to update the items based on the API
          value: comboValue,
          items: comboItems,
          onChanged: (value) {
            if (widget.canEdit) {
              setState(() {
                comboValue = value;
              });
              setValuesInMap(value);
              widget.isChanged(true);
            }
          },
        ),
      ],
    );
  }

  void setValuesInMap(value) {
    var updatedFieldData = widget.fieldData;
    updatedFieldData.value = (value).toString();
    widget.updateValue(updatedFieldData);
  }

  getComboValue(comboItemsList) {
    return comboItemsList.isNotEmpty
        ? widget.vitalsData?.value != null
            ? widget.vitalsData?.value
            : comboValue
        : null;
  }
}
