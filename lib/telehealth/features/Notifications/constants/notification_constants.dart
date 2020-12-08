import 'package:intl/intl.dart';

const String lblNotifications = 'Notifications';
const String lblNoNotification='Looks like there are no notifications';
const String strCancelByDoctor='cancellation by doctor';


String notificationDate(String value) =>
    DateFormat('dd MMM yyyy').format(DateTime.parse(value)).toString();

String notificationTime(String value) =>
    DateFormat('hh:mm a').format(DateTime.parse(value)).toString();

const String qr_notification_fetch =
    'notification-log/user/notifications-list?medium=Push&fromDate=&toDate=';
