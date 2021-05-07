import 'package:flutter/material.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';
import 'form_data_text_field.dart';
import 'form_data_checkbox.dart';
import 'form_data_drop_down.dart';
import 'form_data_radio.dart';

class FormFieldWidget extends StatelessWidget {
  const FormFieldWidget({
    @required this.fieldData,
    @required this.updateValue,
  });

  final FieldModel fieldData;
  final Function(
    FieldModel updatedFieldData, {
    bool isAdd,
    String title,
  }) updateValue;

  @override
  Widget build(BuildContext context) {
    switch (fieldData.ftype) {
      case FieldType.NUMBER:
        return FormDataTextField(
          fieldData: fieldData,
          isNumberOnly: true,
          updateValue: updateValue,
        );
        break;
      case FieldType.CHECKBOX:
        return FormDataCheckbox(
          fieldData: fieldData,
          updateValue: updateValue,
        );
        break;
      case FieldType.TEXT:
        return FormDataTextField(
          fieldData: fieldData,
          updateValue: updateValue,
        );
        break;
      case FieldType.LOOKUP:
        return FormDataDropDown(
          fieldData: fieldData,
          updateValue: updateValue,
        );
        break;
      case FieldType.RADIO:
        return FormDataRadio(
          fieldData: fieldData,
          updateValue: updateValue,
        );
        break;
      default:
        return SizedBox.shrink();
    }
  }
}
