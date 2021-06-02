import 'package:flutter/material.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';
import 'radio_tile_widget.dart';

class FormDataRadio extends StatefulWidget {
  const FormDataRadio({
    @required this.fieldData,
    @required this.updateValue,
    @required this.canEdit,
  });

  final FieldModel fieldData;
  final Function(FieldModel updatedFieldData) updateValue;
  final bool canEdit;

  @override
  _FormDataRadioState createState() => _FormDataRadioState();
}

class _FormDataRadioState extends State<FormDataRadio> {
  dynamic radioGroupValue;
  List<Widget> radioWidget = [];

  @override
  void initState() {
    super.initState();
  }

  List<Widget> loadRadioItems() {
    List<String> radioList = (widget?.fieldData?.fdata ?? '')?.split('|');
    if (radioList?.length > 0 && radioList.length.isEven) {
      radioGroupValue ??= radioList.isNotEmpty ? radioList[0] : null;
      radioWidget.clear();
      for (int index = 0; index < radioList.length; index++) {
        radioWidget.add(
          RadioTileWidget(
            title: radioList[index + 1] ?? '',
            value: radioList[index],
            radioGroupValue: radioGroupValue,
            onSelected: widget.canEdit
                ? (selectedValue) {
                    setState(() {
                      radioGroupValue = selectedValue;
                    });
                    FieldModel updatedFieldData = widget.fieldData;
                    updatedFieldData.value = radioGroupValue.toString();
                    widget.updateValue(updatedFieldData);
                  }
                : null,
          ),
        );
        index++;
      }
    }
    return radioWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: loadRadioItems(),
    );
  }
}
