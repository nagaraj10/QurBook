import 'package:flutter/material.dart';
import '../../models/regiment_data_model.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../../common/CommonUtil.dart';
import '../../models/field_response_model.dart';
import 'radio_tile_widget.dart';

class FormDataRadio extends StatefulWidget {
  const FormDataRadio(
      {required this.fieldData,
      required this.updateValue,
      required this.canEdit,
      this.vitalsData,
      required this.isChanged});

  final FieldModel fieldData;

  final Function(FieldModel updatedFieldData) updateValue;
  final bool canEdit;
  final VitalsData? vitalsData;
  final Function(bool isChanged) isChanged;

  @override
  _FormDataRadioState createState() => _FormDataRadioState();
}

class _FormDataRadioState extends State<FormDataRadio> {
  dynamic radioGroupValue;
  List<Widget> radioWidget = [];

  @override
  void initState() {
    super.initState();
    if (widget.vitalsData?.value != null && widget.vitalsData?.value != "") {
      setValuesInMap(widget.vitalsData?.value);
    }
  }

  List<Widget> loadRadioItems() {
    final radioList = (widget.fieldData.fdata ?? '')?.split('|');
    if (radioList.isNotEmpty && radioList.length.isEven) {
      radioGroupValue ??= getRadioGroupValueNew(radioList);
      radioWidget.clear();
      for (var index = 0; index < radioList.length; index++) {
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
                    setValuesInMap(radioGroupValue);
                    widget.isChanged(true);
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

  getRadioGroupValue(value, index) {
    if (int.parse(value) == index)
      return true;
    else
      return false;
  }

  setValuesInMap(radioGroupValue) {
    var updatedFieldData = widget.fieldData;
    updatedFieldData.value = radioGroupValue.toString();
    widget.updateValue(updatedFieldData);
  }

  getRadioGroupValueNew(radioList) {
    return radioList.isNotEmpty
        ? (widget.vitalsData?.value != null && widget.vitalsData?.value != "")
            ? widget.vitalsData?.value
            : null
        : null;
  }
}
