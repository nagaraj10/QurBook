import 'package:flutter/material.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';

class FormDataRadio extends StatefulWidget {
  const FormDataRadio({
    @required this.fieldData,
    @required this.updateValue,
  });

  final FieldModel fieldData;
  final Function(FieldModel updatedFieldData) updateValue;

  @override
  _FormDataRadioState createState() => _FormDataRadioState();
}

class _FormDataRadioState extends State<FormDataRadio> {
  bool radioValue;
  @override
  Widget build(BuildContext context) {
    radioValue ??= (int.tryParse(widget.fieldData?.value ?? '') ?? 0) == 1;
    return InkWell(
      onTap: () {
        setState(() {
          radioValue = !radioValue;
        });
        FieldModel updatedFieldData = widget.fieldData;
        updatedFieldData.value = (radioValue ? 1 : 0).toString();
        widget.updateValue(updatedFieldData);
      },
      child: Row(
        children: [
          Radio<bool>(
            groupValue: radioValue,
            value: true,
            activeColor: Color(CommonUtil().getMyPrimaryColor()),
            onChanged: (value) {
              setState(() {
                radioValue = !radioValue;
              });
              FieldModel updatedFieldData = widget.fieldData;
              updatedFieldData.value = (radioValue ? 1 : 0).toString();
              widget.updateValue(updatedFieldData);
            },
          ),
          // Radio<bool>(
          //   groupValue: radioValue,
          //   value: false,
          //   activeColor: Color(CommonUtil().getMyPrimaryColor()),
          //   onChanged: (value) {
          //     setState(() {
          //       radioValue = value;
          //     });
          //   },
          // ),
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
