
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({
    this.title,
    this.value,
  });

  final String? title;
  final RegimentFilter? value;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: mAppThemeProvider.primaryColor,
            ),
            child: Radio<RegimentFilter?>(
              groupValue:
                  Provider.of<RegimentViewModel>(context).regimentFilter,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: value,
              activeColor: mAppThemeProvider.primaryColor,
              onChanged: (RegimentFilter? regimenFilter) {
                if (Provider.of<RegimentViewModel>(context, listen: false)
                        .regimentFilter !=
                    regimenFilter) {
                  Provider.of<RegimentViewModel>(context, listen: false)
                      .changeFilter(regimenFilter);
                }
              },
            ),
          ),
          Text(
            title!,
            style: TextStyle(
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w500,
              color: mAppThemeProvider.primaryColor,
            ),
          ),
        ],
      );
}
