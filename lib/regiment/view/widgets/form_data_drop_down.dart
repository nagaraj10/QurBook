import 'package:flutter/material.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../../common/CommonUtil.dart';
import '../../models/field_response_model.dart';
import '../../../constants/fhb_constants.dart' as Constants;

class FormDataDropDown extends StatefulWidget {
  const FormDataDropDown({
    @required this.fieldData,
    @required this.updateValue,
    @required this.canEdit,
  });

  final FieldModel fieldData;
  final Function(FieldModel updatedfieldData) updateValue;
  final bool canEdit;

  @override
  _FormDataDropDownState createState() => _FormDataDropDownState();
}

class _FormDataDropDownState extends State<FormDataDropDown> {
  List<DropdownMenuItem<dynamic>> comboItems = [];
  var comboValue;

  @override
  void initState() {
    super.initState();
    loadComboItems();
  }

  loadComboItems() {
    final comboItemsList = (widget?.fieldData?.fdata ?? '')?.split('|');
    if (comboItemsList.isNotEmpty && comboItemsList.length.isEven) {
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
          widget.fieldData.title,
          style: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w600,
            color: Color(CommonUtil().getMyPrimaryColor()),
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
            (widget.fieldData?.title ?? '').isNotEmpty
                ? '${Constants.select} ${widget.fieldData?.title}'
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
              var updatedFieldData = widget.fieldData;
              updatedFieldData.value = (value).toString();
              widget.updateValue(updatedFieldData);
            }
          },
        ),
      ],
    );
  }
}
