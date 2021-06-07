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
    @required this.canEdit,
  });

  final FieldModel fieldData;
  final bool isNumberOnly;
  final Function(FieldModel updatedFieldData) updateValue;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${fieldData.title} ${((fieldData?.vmin ?? '').isNotEmpty && (fieldData?.vmax ?? '').isNotEmpty) ? '(${fieldData.vmin} - ${fieldData.vmax})' : ''}',
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
          enabled: canEdit,
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
          validator: (value) {
            if (fieldData.title.startsWith('_') && value.isEmpty) {
              return '${fieldData.title} is required';
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }
}
