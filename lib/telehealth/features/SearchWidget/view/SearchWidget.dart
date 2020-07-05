import 'package:flutter/material.dart';

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
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxHeight: 40),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                controller: _searchQueryController,
                autofocus: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(2),
                  hintText: "Search",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  suffixIcon: Visibility(
                    visible:
                        _searchQueryController.text.length >= 3 ? true : false,
                    child: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        _searchQueryController.clear();
                                            widget.onChanged('');

                      },
                    ),
                  ),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black45, fontSize: 12),
                ),
                style: TextStyle(color: Colors.black54, fontSize: 16.0),
                onChanged: (editedValue) {
                    widget.onChanged(editedValue);
                  
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
