
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/authentication/model/Country.dart';
import 'package:myfhb/constants/variable_constant.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class CountryCodePickerPage extends StatefulWidget {
  CountryCodePickerPage({
    @required this.onValuePicked,
    @required this.selectedCountry,
    this.isEnabled = true,
    this.isFromAuthenticationScreen = false,
  });

  Function? onValuePicked;
  Country? selectedCountry;
  bool? isEnabled;
  bool? isFromAuthenticationScreen;
  @override
  _CountryCodePickerState createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePickerPage> {
  @override
  Widget build(BuildContext context) => Center(
        child: PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          enabled: (widget.isEnabled??false),
          padding: const EdgeInsets.all(10),
          elevation: 10,
          color: Colors.grey.shade100,
          initialValue: widget.selectedCountry!.phoneCode,
          onSelected: (item) {
            Country selected;
            if (item == CountryCode.IN) {
              selected = Country(
                countryCode: CountryCode.IN,
                phoneCode: "+91",
                name: "India",
              );
            } else {
              selected = Country(
                countryCode: CountryCode.US,
                phoneCode: "+1",
                name: "US",
              );
            }
            widget.onValuePicked!(selected);
            // setState(() {
            //   widget.selectedCountry = selected;
            // });
          },
          itemBuilder: (context) => <PopupMenuEntry>[
            PopupMenuItem(
                value: CountryCode.IN,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Image(
                          image: AssetImage(icon_IndianFlag),
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'India',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Divider()
                  ],
                )),
            PopupMenuItem(
              value: CountryCode.US,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Image(
                        image: AssetImage(
                          icon_USAFlag,
                        ),
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'United States',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Divider()
                ],
              ),
            ),
          ],
          child: (widget.isFromAuthenticationScreen ?? false)
              ? Container(
                  padding: EdgeInsets.only(
                    top: 7.0,
                    bottom: 7.0,
                  ),
                  margin: EdgeInsets.only(
                    top: 2.0,
                    bottom: 2.0,
                    left: 12.0,
                    right: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBoxWidget(
                        width: 3.0.w,
                      ),
                      Text(
                        widget.selectedCountry!.phoneCode!,
                        style: TextStyle(
                          fontSize: 16.0.sp,
                        ),
                      ),
                      if (widget.isEnabled ?? true)...{
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black54,
                        size: 18.0.sp,
                      ),
                      },
                    ],
                  ),
                )
              : Text(
                  widget.selectedCountry!.phoneCode!,
                  style: TextStyle(
                    fontSize: 16.0.sp,
                  ),
                ),
        ),
      );
}
