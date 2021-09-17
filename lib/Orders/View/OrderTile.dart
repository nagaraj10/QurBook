import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          vertical: 4,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order id : ${order.orderId}',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 2,
            ),
            order.date != null
                ? Text(
                    "${DateFormat('MMMM dd, hh:mm a').format(order.date)}",
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                : Container(),
            const SizedBox(
              height: 4,
            ),
            order.patientFirstName.isNotEmpty
                ? Text(
                    "Patient name : ${order.patientFirstName} ${order.patientLastName} ",
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                : Container(),
            const SizedBox(
              height: 4,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getPlans(context),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (order.feePaid != null && order.feePaid.isNotEmpty)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Paid  ',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            '${CommonUtil.CURRENCY}${double.parse(order.feePaid).toInt()}',
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: Color(
                                        CommonUtil().getMyPrimaryColor(),
                                      ),
                                    ),
                          ),
                        ],
                      )
                    : Container(),
                (order.paymentStatus != null && order.paymentStatus.isNotEmpty)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Text(
                          //   'Payment status : ',
                          //   style: Theme.of(context).textTheme.bodyText2,
                          // ),
                          Text(
                            order.paymentStatus,
                            style:
                                Theme.of(context).textTheme.bodyText2.copyWith(
                                      color: getColor(order.paymentStatus),
                                    ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            MySeparator(
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Color getColor(String status) {
    switch (status) {
      case 'Payment Initiated':
      case 'Payment Pending':
      case 'Payment Link Disabled':
        return Colors.orange;
        break;
      case 'Payment Success':
        return Colors.green;
        break;
      case 'Payment Failed':
        return Colors.red;
        break;
      default:
        return Colors.orange;
        break;
    }
  }

  List<Widget> getPlans(BuildContext context) {
    List<Widget> plans = [];

    for (var i = 0; i < order.plans.length; i++) {
      final widget = Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 4,
              ),
              child: Text(
                ' * ',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            SizedBox(
              width: 4,
            ),
            // i == 0
            //     ? Text(
            //         'Subscription -',
            //         textAlign: TextAlign.left,
            //         style: Theme.of(context).textTheme.bodyText1,
            //       )
            //     : Container(),
            Expanded(
              child: Text(
                order.plans[i],
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      );
      plans.add(widget);
    }
    return plans;
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({
    this.height = 1,
    this.color = Colors.grey,
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
