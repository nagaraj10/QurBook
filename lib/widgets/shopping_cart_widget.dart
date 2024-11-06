import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/Notifications/view/notification_main.dart';
import 'package:myfhb/widgets/checkout_page_provider.dart';
import 'package:provider/provider.dart';

import '../constants/router_variable.dart';

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
        child:  GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              rt_notification_main,
            );
          },
          child: Stack(
            children: <Widget>[
               IconButton(
                icon:  Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: null,
              ),
              cartCount == 0
                  ?  Container()
                  :  Positioned(
                      child:  Stack(
                        children: <Widget>[
                           Icon(
                            Icons.brightness_1,
                            size: cartCount <= 99 ? 20.0 : 25.0,
                            color: ColorUtils.countColor,
                          ),
                           Positioned(
                            top: 3.0,
                            right: 4.0,
                            child:  Center(
                              child:  Text(
                                cartCount <= 99 ? '${cartCount}' : '99+',
                                style: TextStyle(
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
