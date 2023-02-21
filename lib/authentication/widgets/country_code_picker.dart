import 'package:flutter/material.dart';
import 'package:myfhb/authentication/model/Country.dart';
import '../constants/constants.dart' as constants;
import '../../common/CommonUtil.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class CountryCodePickerPage extends StatefulWidget {
  CountryCodePickerPage({
    @required this.onValuePicked,
    @required this.selectedCountry,
  });

  Function onValuePicked;
  Country selectedCountry;
  @override
  _CountryCodePickerState createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePickerPage> {
  @override
  Widget build(BuildContext context) => Center(
        child: PopupMenuButton(
          initialValue: widget.selectedCountry.phoneCode,
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
            widget.onValuePicked(selected);
            // setState(() {
            //   widget.selectedCountry = selected;
            // });
          },
          itemBuilder: (context) => <PopupMenuEntry>[
            PopupMenuItem(
              value: CountryCode.IN,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    child: Text(
                      '+(91)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0.sp,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text('India'),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: CountryCode.US,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    child: Text(
                      '+(1)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0.sp,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text('US'),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ],
          child: Text(widget.selectedCountry.phoneCode,
              style: TextStyle(
                fontSize: 16.0.sp,
              )),
        ),
      );
}
