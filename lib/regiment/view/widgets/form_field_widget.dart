
import 'package:flutter/material.dart';
import '../../models/regiment_data_model.dart';
import '../../models/field_response_model.dart';
import 'form_data_text_field.dart';
import 'form_data_checkbox.dart';
import 'form_data_drop_down.dart';
import 'form_data_radio.dart';

class FormFieldWidget extends StatelessWidget {
  const FormFieldWidget({
    required this.fieldData,
    required this.updateValue,
    required this.canEdit,
    this.isFromQurHomeSymptom = false,
    this.isFromQurHomeRegimen = false,
  });

  final FieldModel fieldData;
  final Function(
    FieldModel updatedFieldData, {
    bool? isAdd,
    String? title,
  }) updateValue;
  final bool canEdit;
  final bool isFromQurHomeSymptom;
  final bool isFromQurHomeRegimen;

  @override
  Widget build(BuildContext context) {
    switch (fieldData.ftype) {
      case FieldType.NUMBER:
        return FormDataTextField(
          fieldData: fieldData,
          isNumberOnly: true,
          updateValue: updateValue,
          canEdit: canEdit,
          isFromQurHomeSymptom: isFromQurHomeSymptom,
          isFromQurHomeRegimen: isFromQurHomeRegimen,
        );
        break;
      case FieldType.CHECKBOX:
        return FormDataCheckbox(
            fieldData: fieldData,
            updateValue: updateValue,
            isFromQurHomeSymptom: isFromQurHomeSymptom,
            isFromQurHomeRegimen: isFromQurHomeRegimen,
            canEdit: canEdit);
        break;
      case FieldType.TEXT:
        return FormDataTextField(
          fieldData: fieldData,
          updateValue: updateValue,
          canEdit: canEdit,
          isFromQurHomeSymptom: isFromQurHomeSymptom,
          isFromQurHomeRegimen: isFromQurHomeRegimen,
        );
        break;
      case FieldType.LOOKUP:
        return FormDataDropDown(
          fieldData: fieldData,
          updateValue: updateValue,
          canEdit: canEdit,
          isFromQurHomeSymptom: isFromQurHomeSymptom,
          isFromQurHomeRegimen: isFromQurHomeRegimen,
        );
        break;
      case FieldType.RADIO:
        return FormDataRadio(
          fieldData: fieldData,
          updateValue: updateValue,
          canEdit: canEdit,
        );
        break;
      default:
        return const SizedBox.shrink();
    }
  }
}
