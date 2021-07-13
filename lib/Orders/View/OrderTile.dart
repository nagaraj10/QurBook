import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myfhb/Orders/Model/OrderModel.dart';
import 'package:myfhb/common/CommonUtil.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;
  const OrderTile({
    @required this.order,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OrderId : ${order.orderId}',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              order.title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              order.purchaseDate,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Column(
              children: order.plans
                  .map(
                    (e) => getPlanTile(context),
                  )
                  .toList(),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Paid : ",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  "INR ${order.totalAmount}",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: Color(
                          CommonUtil().getMyPrimaryColor(),
                        ),
                      ),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            MySeparator(),
          ],
        ),
      ),
    );
  }

  Container getPlanTile(BuildContext context) => Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
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
      );
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({
    this.height = 1,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 5.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(
            dashCount,
            (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                  ),
                ),
              );
            },
          ),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
