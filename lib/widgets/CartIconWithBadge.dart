import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/telehealth/features/chat/view/BadgeIcon.dart';
import 'package:provider/provider.dart';
import 'checkout_page_provider.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class CartIconWithBadge extends StatelessWidget {
  Color color;
  double size;
  CartIconWithBadge({@required this.color,@required this.size});
  @override
  Widget build(BuildContext context) {
    return BadgeIcon(
      icon: GestureDetector(
        child: Icon(
          Icons.add_shopping_cart,
          color: color,
          size: size,
        ),
      ),
      badgeColor: ColorUtils.countColor,
      badgeCount: Provider.of<CheckoutPageProvider>(context)?.currentCartCount,
    );
  }
}
