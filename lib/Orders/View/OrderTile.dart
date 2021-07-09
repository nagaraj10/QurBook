import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myfhb/Orders/Model/OrderModel.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;
  const OrderTile({
    @required this.order,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                //if (order.imageURL.isNotEmpty)
                Image(
                  image: const AssetImage(
                    icon_maya,
                  ),
                  height: 40.0.h,
                  width: 40.0.h,
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 2,
                        ),
                        child: Text(
                          order.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Text(
                        order.purchaseDate,
                        style: Theme.of(context).textTheme.bodyText2,
                      )
                    ],
                  ),
                )
              ],
            ),
            getPlanTile(context),
            getPlanTile(context),
            getPlanTile(context),
            getPlanTile(context),
            getPlanTile(context),
            getPlanTile(context),
            getPlanTile(context),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                "Total  : ${order.totalAmount}",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container getPlanTile(BuildContext context) => Container(
        width: double.infinity,
        child: Card(
          color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.plans[0].title,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
      );
}
