import 'package:flutter/material.dart';

import '../../../../common/CommonConstants.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../widgets/common_components.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class SearchWidget extends StatefulWidget {
  final void Function(String) onChanged;
  final TextEditingController searchController;
  final FocusNode searchFocus;

  const SearchWidget({
    Key key,
    this.onChanged,
    this.searchController,
    this.searchFocus,
  }) : super(key: key);

  @override
  SearchWdigetState createState() => SearchWdigetState();
}

class SearchWdigetState extends State<SearchWidget> {
  TextEditingController _searchQueryController;

  @override
  void initState() {
    super.initState();
    _searchQueryController = widget.searchController ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Padding(
          padding: EdgeInsets.only(top: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 40.0.h),
                  decoration: BoxDecoration(color: Colors.white),
                  child: TextField(
                    controller: _searchQueryController,
                    focusNode: widget.searchFocus,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(4),
                      hintText: variable.strSearch,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black54,
                        size: 24.0.sp,
                      ),
                      suffixIcon: Visibility(
                        visible: _searchQueryController.text.length >= 3
                            ? true
                            : false,
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.black54,
                            size: 24.0.sp,
                          ),
                          onPressed: () {
                            _searchQueryController.clear();
                            widget.onChanged('');
                          },
                        ),
                      ),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.black45,
                        fontSize: 16.0.sp,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16.0.sp,
                    ),
                    onChanged: (editedValue) {
                      widget.onChanged(editedValue);
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
