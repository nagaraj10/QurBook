import 'package:flutter/material.dart';
import '../../models/regiment_data_model.dart';
import '../../models/field_response_model.dart';
import 'form_data_text_field.dart';
import 'form_data_checkbox.dart';
import 'form_data_drop_down.dart';
import 'form_data_radio.dart';

class FormFieldWidget extends StatelessWidget {
  const FormFieldWidget(
      {required this.fieldData,
      required this.updateValue,
      required this.canEdit,
      this.isFromQurHomeSymptom = false,
      this.isFromQurHomeRegimen = false,
      this.vitalsData,
      required this.isChanged});

  final FieldModel fieldData;

  final Function(bool isChanged) isChanged;
  final Function(
    FieldModel updatedFieldData, {
    bool? isAdd,
    String? title,
  }) updateValue;
  final bool canEdit;
  final bool isFromQurHomeSymptom;
  final bool isFromQurHomeRegimen;
  final VitalsData? vitalsData;

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
          vitalsData: vitalsData,
          isChanged: isChanged,
        );
        break;
      case FieldType.CHECKBOX:
        return FormDataCheckbox(
          fieldData: fieldData,
          updateValue: updateValue,
          isFromQurHomeSymptom: isFromQurHomeSymptom,
          canEdit: canEdit,
          vitalsData: vitalsData,
          isChanged: isChanged,
        );
        break;
      case FieldType.TEXT:
        return FormDataTextField(
          fieldData: fieldData,
          updateValue: updateValue,
          canEdit: canEdit,
          isFromQurHomeSymptom: isFromQurHomeSymptom,
          vitalsData: vitalsData,
          isChanged: isChanged,
        );
        break;
      case FieldType.LOOKUP:
        return FormDataDropDown(
          fieldData: fieldData,
          updateValue: updateValue,
          canEdit: canEdit,
          isFromQurHomeSymptom: isFromQurHomeSymptom,
          vitalsData: vitalsData,
          isChanged: isChanged,
        );
        break;
      case FieldType.RADIO:
        return FormDataRadio(
          fieldData: fieldData,
          updateValue: updateValue,
          canEdit: canEdit,
          vitalsData: vitalsData,
          isChanged: isChanged,
        );
        break;
      default:
        return const SizedBox.shrink();
    }
  }
}
