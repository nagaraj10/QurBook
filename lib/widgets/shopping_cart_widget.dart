import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
import 'package:myfhb/widgets/shopping_card_provider.dart';
import 'package:provider/provider.dart';

class ShoppingCartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cartCount = Provider.of<CheckoutPageProvider>(context).currentCartCount;
    return Container(
      height: 50,
      width: 50,
      child: Container(
        height: 150.0,
        width: 50.0,
        child: new GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) => new NotificationMain(),
              ),
            );
          },
          child: new Stack(
            children: <Widget>[
              new IconButton(
                icon: new Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: null,
              ),
              cartCount == 0
                  ? new Container()
                  : new Positioned(
                      child: new Stack(
                        children: <Widget>[
                          new Icon(
                            Icons.brightness_1,
                            size: cartCount <= 99 ? 20.0 : 25.0,
                            color: ColorUtils.countColor,
                          ),
                          new Positioned(
                            top: 3.0,
                            right: 4.0,
                            child: new Center(
                              child: new Text(
                                cartCount <= 99 ? '${cartCount}' : '99+',
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
