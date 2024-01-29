import 'package:cron/cron.dart';

import '../../common/firestore_services.dart';

class CronJobServices {
  static final _cronJob = Cron();

  // Schedule the cron job to run at midnight for getting the latest regiment
  void scheduleUpdateForData() {
    _cronJob.schedule(
      Schedule.parse('0 0 * * *'),
      () {
        FirestoreServices().updateDataFor(
          'all',
          withLoading: true,
        );
      },
    );
  }
}
