import 'package:flutter/material.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';

class FormDataCheckbox extends StatefulWidget {
  const FormDataCheckbox({
    @required this.fieldData,
    @required this.updateValue,
  });

  final FieldModel fieldData;
  final Function(FieldModel updatedFieldData) updateValue;
  @override
  _FormDataCheckboxState createState() => _FormDataCheckboxState();
}

class _FormDataCheckboxState extends State<FormDataCheckbox> {
  bool checkBoxValue;
  @override
  Widget build(BuildContext context) {
    checkBoxValue ??= (int.tryParse(widget.fieldData?.value ?? '') ?? 0) == 1;
    return InkWell(
      onTap: () {
        setState(() {
          checkBoxValue = !checkBoxValue;
        });
        FieldModel updatedFieldData = widget.fieldData;
        updatedFieldData.value = (checkBoxValue ? 1 : 0).toString();
        widget.updateValue(updatedFieldData);
      },
      child: Row(
        children: [
          Checkbox(
            value: checkBoxValue,
            activeColor: Color(CommonUtil().getMyPrimaryColor()),
            onChanged: (value) {
              setState(() {
                checkBoxValue = value;
              });
              FieldModel updatedFieldData = widget.fieldData;
              updatedFieldData.value = (checkBoxValue ? 1 : 0).toString();
              widget.updateValue(updatedFieldData);
            },
          ),
          SizedBox(
            width: 2.0.w,
          ),
          Text(
            widget.fieldData.title ?? '',
            style: TextStyle(
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
