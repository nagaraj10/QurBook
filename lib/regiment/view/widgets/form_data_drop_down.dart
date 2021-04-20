import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';

class FormDataDropDown extends StatelessWidget {
  FormDataDropDown({
    @required this.fieldData,
    @required this.updateValue,
  });

  final FieldModel fieldData;
  final Function(FieldModel updatedfieldData) updateValue;

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
        DropdownButton(
          style: TextStyle(
            fontSize: 16.0.sp,
          ),
          isExpanded: true,
          //TODO: Need to update the items based on the API
          items: [],
          onChanged: (value) {
            FieldModel updatedFieldData = fieldData;
            updatedFieldData.value = (value).toString();
            updateValue(updatedFieldData);
          },
        ),
      ],
    );
  }
}
