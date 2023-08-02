import 'package:flutter/material.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../../common/CommonUtil.dart';
import '../../models/field_response_model.dart';
import 'checkbox_tile_widget.dart';

class FormDataCheckbox extends StatefulWidget {
  const FormDataCheckbox(
      {required this.fieldData,
      required this.updateValue,
      required this.canEdit,
      this.isFromQurHomeSymptom = false,
      this.vitalsData,
      required this.isChanged});

  final FieldModel fieldData;
  final Function(
    FieldModel updatedFieldData, {
    bool? isAdd,
    String? title,
  }) updateValue;
  final bool canEdit;
  final bool isFromQurHomeSymptom;
  final VitalsData? vitalsData;
  final Function(bool isChanged) isChanged;

  @override
  _FormDataCheckboxState createState() => _FormDataCheckboxState();
}

class _FormDataCheckboxState extends State<FormDataCheckbox> {
  List<Widget> checkboxWidget = [];
  List checkBoxListSelected = [];

  @override
  void initState() {
    super.initState();
    try {
      checkBoxListSelected = getSelectedValue(widget.vitalsData);
      if (checkBoxListSelected != null && checkBoxListSelected.length > 0) {
        for (String val in checkBoxListSelected) {
          if (val != "" && val != null) {
            setValuesInCheckbox(true, val);
          }
        }
      }
    } catch (e) {
                  CommonUtil().appLogs(message: e.toString());

    }
  }

  List<Widget> loadCheckboxItems() {
    final checkboxList = (widget.fieldData.fdata ?? '')?.split('|');
    if (checkboxList.isNotEmpty && checkboxList.length.isEven) {
      checkboxWidget.clear();
      for (var index = 0; index < checkboxList.length; index++) {
        checkboxWidget.add(
          CheckboxTileWidget(
            canEdit: widget.canEdit,
            title: checkboxList[index + 1] ?? '',
            value: checkboxList[index],
            checkBoxValue:
                getCondition(checkBoxListSelected, checkboxList[index]),
            onSelected: (selectedValue, valueText) {
              setValuesInCheckbox(selectedValue, valueText);
              widget.isChanged(true);
            },
          ),
        );
        index++;
      }
    }
    return checkboxWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.fieldData != null)
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
            height: 5.0.h,
          ),
          Column(
            children: loadCheckboxItems(),
          ),
        ],
      ),
    );
  }

  getSelectedValue(VitalsData? vitalsData) {
    var selectedCheckboxItems = vitalsData?.value?.toString().split("|");
    return selectedCheckboxItems;
  }

  getCondition(var checkedList, String title) {
    try {
      bool condition = false;
      if (checkedList.contains(title))
        return true;
      else
        return false;
    } catch (e) {
                  CommonUtil().appLogs(message: e.toString());

      return false;
    }
  }

  void setValuesInCheckbox(selectedValue, valueText) {
    final updatedFieldData = widget.fieldData;
    updatedFieldData.value = valueText;
    if (selectedValue) {
      widget.updateValue(updatedFieldData,
          isAdd: true, title: '${updatedFieldData.title}_$valueText');
    } else {
      widget.updateValue(updatedFieldData,
          isAdd: false, title: '${updatedFieldData.title}_$valueText');
    }
  }
}
