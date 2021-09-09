import 'package:intl/intl.dart';

const String lblNotifications = 'Notifications';
const String lblNoNotification = 'Looks like there are no notifications';
const String strCancelByDoctor = 'DoctorCancellation';
const String strRescheduleByDoctor = 'DoctorRescheduling';
const String strMyCardDetails = 'myCartDetails';
const String strRemiderPreFrequency7 = 'PlanExpiryReminderPrefrequency7';
const String strRemiderPreFrequency3 = 'PlanExpiryReminderPrefrequency3';
const String strRemiderPreFrequency1 = 'PlanExpiryReminderPrefrequency1';
const String strRemiderPostFrequency1 = 'PlanExpiryReminderPostfrequency1';
const String strRemiderPostFrequency3 = 'PlanExpiryReminderPostfrequency3';
const String strRemiderPostFrequency7 = 'PlanExpiryReminderPostfrequency7';
const String strRemiderPostFrequency14 = 'PlanExpiryReminderPostfrequency14';

String notificationDate(String value) =>
    DateFormat('dd MMM yyyy').format(DateTime.parse(value)).toString();

String notificationTime(String value) =>
    DateFormat('hh:mm a').format(DateTime.parse(value)).toString();

const String qr_notification_fetch =
    'notification-log/user/notifications-list?medium=Push&fromDate=&toDate=';

const String qr_notification_action = 'notification-log/actions';
const String qr_notification_action_ontap = 'notification-log/on-tap';
const String qr_notification_clear = 'notification-log/clear-notifications';
