import 'package:intl/intl.dart';

const String lblNotifications = 'Notifications';
const String lblNoNotification='Looks Like There is No Notifications!!';

String notificationDate(String value) =>
    DateFormat('dd MMM yyyy').format(DateTime.parse(value)).toString();

String notificationTime(String value) =>
    DateFormat('hh:mm a').format(DateTime.parse(value)).toString();

const String qr_notification_fetch =
    'notification-log/user/notifications-list?medium=Push&fromDate=&toDate=';
