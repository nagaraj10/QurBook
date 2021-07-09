import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myfhb/Orders/Model/OrderModel.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;
  const OrderTile({
    @required this.order,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(
          4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Row(
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
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 4,
                      bottom: 4,
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
            ),
            Column(
              children: order.plans
                  .map(
                    (e) => getPlanTile(context),
                  )
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total : ",
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
