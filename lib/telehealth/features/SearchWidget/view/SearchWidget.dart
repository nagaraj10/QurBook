import 'package:flutter/material.dart';

import '../../../../common/CommonConstants.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../common/CommonUtil.dart';
import '../../../../widgets/common_components.dart';

class SearchWidget extends StatefulWidget {
  final void Function(String) onChanged;

  const SearchWidget({Key key, this.onChanged}) : super(key: key);

  @override
  SearchWdigetState createState() => SearchWdigetState();
}

class SearchWdigetState extends State<SearchWidget> {
  TextEditingController _searchQueryController = TextEditingController();

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
                  constraints: BoxConstraints(maxHeight: 40),
                  decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        Color(CommonUtil().getMyPrimaryColor()),
                        Color(CommonUtil().getMyGredientColor())
                      ])),
                  child: TextField(
                    controller: _searchQueryController,
                    cursorColor: Colors.white,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(2),
                      hintText: "Search",
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      suffixIcon: Visibility(
                        visible: _searchQueryController.text.length >= 3
                            ? true
                            : false,
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _searchQueryController.clear();
                            widget.onChanged('');
                          },
                        ),
                      ),
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
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
