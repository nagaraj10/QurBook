import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:flutter/services.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';

class FormDataTextField extends StatelessWidget {
  FormDataTextField({
    @required this.fieldData,
    this.isNumberOnly = false,
    @required this.updateValue,
  });

  final FieldModel fieldData;
  final bool isNumberOnly;
  final Function(FieldModel updatedFieldData) updateValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldData.title,
          style: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w600,
            color: Color(CommonUtil().getMyPrimaryColor()),
          ),
        ),
        SizedBox(
          height: 10.0.h,
        ),
        TextFormField(
          style: TextStyle(
            fontSize: 16.0.sp,
          ),
          keyboardType: isNumberOnly ? TextInputType.number : null,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                10.0.sp,
              ),
            ),
          ),
          onChanged: (value) {
            FieldModel updatedFieldData = fieldData;
            updatedFieldData.value = value;
            updateValue(updatedFieldData);
          },
          inputFormatters: [
            if (isNumberOnly) FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ],
    );
  }
}
