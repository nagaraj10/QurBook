import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class SearchWidgetWizard extends StatelessWidget {

  final Function(String) onChanged;
  final String hintText;

  SearchWidgetWizard(this.onChanged,this.hintText);

  TextEditingController _searchQueryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          left: 20.0.w,
          right: 20.0.w,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 10.0.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 40.0.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(
                      5.0.sp,
                    ),
                  ),
                  child: TextField(
                    controller: _searchQueryController,
                    autofocus: false,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 12.0.sp,bottom: 15.0.sp),
                      hintText: hintText,
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
                    onChanged: (value) {
                      if (value.trim().length > 1) {
                        /*setState(() {
                          isSearch = true;
                          *//*upcomingInfo = appointmentsViewModel
                              .filterSearchResults(value)
                              .upcoming;
                          historyInfo = appointmentsViewModel
                              .filterSearchResults(value)
                              .past;*//*
                        });*/
                      } else {
                        /*setState(() {
                          isSearch = false;
                         *//* upcomingInfo.clear();
                          historyInfo.clear();*//*
                        });*/
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
