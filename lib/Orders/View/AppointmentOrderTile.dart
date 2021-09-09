import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/Orders/Model/OrderModel.dart';
import 'package:myfhb/Orders/View/OrderTile.dart';
import 'package:myfhb/common/CommonUtil.dart';

class AppointmentOrderTile extends StatelessWidget {
  final OrderModel order;
  const AppointmentOrderTile({
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
                    "Date of Payment : ${DateFormat('MMMM dd, hh:mm a').format(order.date)}",
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
            order.doctorFirstName.isNotEmpty
                ? Text(
                    "Doctor name : ${order.doctorFirstName} ${order.doctorLastName} ",
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                : Container(),
            const SizedBox(
              height: 4,
            ),
            order.appointmentDateTime != null
                ? Text(
                    "Appointment Date : ${DateFormat('MMMM dd, hh:mm a').format(order.appointmentDateTime)}",
                    style: Theme.of(context).textTheme.bodyText2,
                  )
                : Container(),
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
}
