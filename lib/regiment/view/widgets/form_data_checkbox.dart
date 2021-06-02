import 'package:flutter/material.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';
import 'checkbox_tile_widget.dart';

class FormDataCheckbox extends StatefulWidget {
  const FormDataCheckbox({
    @required this.fieldData,
    @required this.updateValue,
    @required this.canEdit,
  });

  final FieldModel fieldData;
  final Function(
    FieldModel updatedFieldData, {
    bool isAdd,
    String title,
  }) updateValue;
  final bool canEdit;

  @override
  _FormDataCheckboxState createState() => _FormDataCheckboxState();
}

class _FormDataCheckboxState extends State<FormDataCheckbox> {
  List<Widget> checkboxWidget = [];

  @override
  void initState() {
    super.initState();
  }

  List<Widget> loadCheckboxItems() {
    List<String> checkboxList = (widget?.fieldData?.fdata ?? '')?.split('|');
    if (checkboxList?.length > 0 && checkboxList.length.isEven) {
      checkboxWidget.clear();
      for (int index = 0; index < checkboxList.length; index++) {
        checkboxWidget.add(
          CheckboxTileWidget(
            canEdit: widget.canEdit,
            title: checkboxList[index + 1] ?? '',
            value: checkboxList[index],
            onSelected: (selectedValue, valueText) {
              FieldModel updatedFieldData = widget.fieldData;
              updatedFieldData.value = valueText;
              if (selectedValue) {
                widget.updateValue(updatedFieldData,
                    isAdd: true, title: '${updatedFieldData.title}_$valueText');
              } else {
                widget.updateValue(updatedFieldData,
                    isAdd: false,
                    title: '${updatedFieldData.title}_$valueText');
              }
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
    return Column(
      children: loadCheckboxItems(),
    );
  }
}
