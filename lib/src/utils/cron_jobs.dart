import 'package:cron/cron.dart';

import '../../common/firestore_services.dart';

class CronJobServices {
  // Create a singleton instance of the Cron class
  static final _cronJob = Cron();

  // Schedule the cron job to run at midnight for getting the latest regiment
  void scheduleUpdateForData() {
    // Use the Cron instance to schedule a job at midnight (0 0 * * *)
    _cronJob.schedule(
      Schedule.parse('0 0 * * *'),
      // Callback function to be executed when the cron job runs
      () {
        // Call the updateDataFor method from FirestoreServices
        FirestoreServices().updateDataFor(
          'all', // Pass the parameter 'all'
          withLoading: true, // Pass the parameter withLoading as true
        );
      },
    );
  }
}
