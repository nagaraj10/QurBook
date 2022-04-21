import 'package:flutter/material.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../../common/CommonUtil.dart';
import 'package:flutter/services.dart';
import '../../models/regiment_data_model.dart';
import '../../models/field_response_model.dart';

class FormDataTextField extends StatelessWidget {
  const FormDataTextField({
    @required this.fieldData,
    this.isNumberOnly = false,
    this.isFromQurHome = false,
    @required this.updateValue,
    @required this.canEdit,
  });

  final FieldModel fieldData;
  final bool isNumberOnly;
  final Function(FieldModel updatedFieldData) updateValue;
  final bool canEdit;
  final bool isFromQurHome;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${fieldData.title}',
          style: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.w600,
            color: isFromQurHome
                ? Color(CommonUtil()
                .getQurhomePrimaryColor())
                : Color(
                CommonUtil().getMyPrimaryColor()),
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
          keyboardType: isNumberOnly
              ? TextInputType.numberWithOptions(
                  decimal: true,
                )
              : null,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                10.0.sp,
              ),
            ),
          ),
          onChanged: (value) {
            final updatedFieldData = fieldData;
            updatedFieldData.value = value;
            updateValue(updatedFieldData);
          },
          inputFormatters: [
            // if (isNumberOnly) FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (fieldData.title.startsWith('_') && value.isEmpty) {
              return '${fieldData.title} is required';
            } else if (isNumberOnly &&
                (fieldData?.vmin ?? '').isNotEmpty &&
                (fieldData?.vmax ?? '').isNotEmpty) {
              if (value?.isEmpty) {
                return '${fieldData.title} is required';
              } else if (isNumberOnly) {
                if (((double.tryParse(value) ?? 0) <
                        (double.tryParse(fieldData?.vmin) ?? 0)) ||
                    ((double.tryParse(value) ?? 0) >
                        (double.tryParse(fieldData?.vmax) ?? 0))) {
                  return 'Enter a valid ${fieldData.title}';
                } else {
                  return null;
                }
              } else {
                return null;
              }
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }
}
