import 'package:flutter/material.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

class CommonComponents {
  getOutlineButton(String buttonText, onPressed) {
    return OutlineButton(
        child: Text(buttonText),
        onPressed: () {
          onPressed();
        });
  }

  getTextField(String hintString) {
    return TextField(
      keyboardType: TextInputType.phone,
      decoration:
          InputDecoration(hintText: hintString, border: InputBorder.none),
    );
  }

  showSnackBar(String message, BuildContext context, Color color) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(message, style: TextStyle(color: Colors.white)),
    ));
  }

  showOverlayMessage(
      BuildContext context, String message, dynamic icon, Color color) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: 20.0,
            //left: 20.0,
            width: MediaQuery.of(context).size.width,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(10.0),
                margin: new EdgeInsets.all(20.0),
                decoration: new BoxDecoration(
                  color: color,
                  shape: BoxShape.rectangle,
                  borderRadius: new BorderRadius.circular(30.0),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20.0,
                      offset: new Offset(0.0, 5.0),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        message,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: variable.font_roboto,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ],
                ),
              ),
            )));
    overlayState.insert(overlayEntry);
    await Future.delayed(Duration(seconds: 2));
    overlayEntry.remove();
  }
}
