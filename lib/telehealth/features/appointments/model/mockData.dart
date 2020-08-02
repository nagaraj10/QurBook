import 'package:myfhb/telehealth/features/appointments/model/appointmentsModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/doctorsData.dart';
import 'package:myfhb/telehealth/features/appointments/model/healthRecord.dart';
import 'package:myfhb/telehealth/features/appointments/model/historyModel.dart';
import 'package:myfhb/telehealth/features/appointments/model/notesModel.dart';

var doctorsData = AppointmentsModel(
    status: "200",
    success: true,
    message: "Fetched the list of appointment(s) detail",
    response: Response(
        count: '2',
        data: DoctorsData(history: [
          History(
              status: 'Orthopedic and Surgeon',
              actualEndDateTime: '2020-07-31 24:00:00',
              actualStartDateTime: '10.45 AM',
              appointmentId: '',
              bookingId: '',
              createdBy: '',
              createdOn: '',
              doctorId: '',
              doctorName: 'Dr.Ragunathan',
              doctorPic: '',
              doctorSessionId: '',
              followupDate: 'Fri, Mar 15 2020',
              followupFee: 'INR 320',
              healthRecord: [
                HealthRecord(
                    prescription: [
                      Notes(mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777")
                    ],
                    notes: Notes(
                        mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777"),
                    others: ["c3476695-99f2-4062-8694-29139c384a04"],
                    voice: Notes(
                        mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777")),
              ],
              isMedicalRecordsShared: '',
              isRefunded: '',
              lastModifiedBy: '',
              location: 'Chennai',
              patientId: '',
              plannedEndDateTime: '',
              plannedStartDateTime: '',
              sharedMedicalRecordsId: '',
              slotNumber: '5',
              specialization: ''),
          History(
              status: 'Pediatrician',
              actualEndDateTime: '2020-08-01 12:00:00',
              actualStartDateTime: '09.55 AM',
              appointmentId: '',
              bookingId: '',
              createdBy: '',
              createdOn: '',
              doctorId: '',
              doctorName: 'Dr.M.Manimala',
              doctorPic: '',
              doctorSessionId: '',
              followupDate: 'Wed, Jun 22 2020',
              followupFee: 'INR 350',
              healthRecord: [
                HealthRecord(
                    prescription: [
                      Notes(mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777")
                    ],
                    notes: Notes(
                        mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777"),
                    others: ["c3476695-99f2-4062-8694-29139c384a04"],
                    voice: Notes(
                        mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777")),
              ],
              isMedicalRecordsShared: '',
              isRefunded: '',
              lastModifiedBy: '',
              location: 'Trichy',
              patientId: '',
              plannedEndDateTime: '',
              plannedStartDateTime: '',
              sharedMedicalRecordsId: '',
              slotNumber: '7',
              specialization: ''),
          History(
              status: 'General Physician',
              actualEndDateTime: '2020-08-02 12:00:00',
              actualStartDateTime: '11.45 AM',
              appointmentId: '',
              bookingId: '',
              createdBy: '',
              createdOn: '',
              doctorId: '',
              doctorName: 'Dr.Jacky',
              doctorPic: '',
              doctorSessionId: '',
              followupDate: 'Fri, Dec 15 2020',
              followupFee: 'INR 320',
              healthRecord: [
                HealthRecord(
                    prescription: [
                      Notes(mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777")
                    ],
                    notes: Notes(
                        mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777"),
                    others: ["c3476695-99f2-4062-8694-29139c384a04"],
                    voice: Notes(
                        mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777")),
              ],
              isMedicalRecordsShared: '',
              isRefunded: '',
              lastModifiedBy: '',
              location: 'Coimbatore',
              patientId: '',
              plannedEndDateTime: '',
              plannedStartDateTime: '',
              sharedMedicalRecordsId: '',
              slotNumber: '5',
              specialization: '')
        ], upcoming: [
          History(
              status: 'Orthopedic and Surgeon',
              actualEndDateTime: '2020-08-02 24:00:00',
              actualStartDateTime: '17.45 PM',
              appointmentId: '',
              bookingId: '',
              createdBy: '',
              createdOn: '',
              doctorId: '',
              doctorName: 'Dr.Raghunathan',
              doctorPic: '',
              doctorSessionId: '',
              followupDate: 'Fri, Mar 15 2020',
              followupFee: 'INR 320',
              healthRecord: [
                HealthRecord(
                    prescription: [
                      Notes(mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777")
                    ],
                    notes: Notes(
                        mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777"),
                    others: ["c3476695-99f2-4062-8694-29139c384a04"],
                    voice: Notes(
                        mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777")),
              ],
              isMedicalRecordsShared: '',
              isRefunded: '',
              lastModifiedBy: '',
              location: 'Chennai',
              patientId: '',
              plannedEndDateTime: '',
              plannedStartDateTime: '',
              sharedMedicalRecordsId: '',
              slotNumber: '5',
              specialization: ''),
          History(
              status: 'Pediatrician',
              actualEndDateTime: '2020-08-02 12:00:00',
              actualStartDateTime: '18.00 PM',
              appointmentId: '',
              bookingId: '',
              createdBy: '',
              createdOn: '',
              doctorId: '',
              doctorName: 'Abanya',
              doctorPic: '',
              doctorSessionId: '',
              followupDate: 'Wed, Jun 22 2020',
              followupFee: 'INR 350',
              healthRecord: [
                HealthRecord(
                    prescription: [
                      Notes(mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777")
                    ],
                    notes: Notes(
                        mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777"),
                    others: ["c3476695-99f2-4062-8694-29139c384a04"],
                    voice: Notes(
                        mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777")),
              ],
              isMedicalRecordsShared: '',
              isRefunded: '',
              lastModifiedBy: '',
              location: 'Trichy',
              patientId: '',
              plannedEndDateTime: '',
              plannedStartDateTime: '',
              sharedMedicalRecordsId: '',
              slotNumber: '7',
              specialization: ''),
          History(
              status: 'General Physician',
              actualEndDateTime: '2020-08-04 12:00:00',
              actualStartDateTime: '11.45 AM',
              appointmentId: '',
              bookingId: '',
              createdBy: '',
              createdOn: '',
              doctorId: '',
              doctorName: 'Raguvaran',
              doctorPic: '',
              doctorSessionId: '',
              followupDate: 'Fri, Dec 15 2020',
              followupFee: 'INR 320',
              healthRecord: [
                HealthRecord(
                    prescription: [
                      Notes(mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777")
                    ],
                    notes: Notes(
                        mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777"),
                    others: ["c3476695-99f2-4062-8694-29139c384a04"],
                    voice: Notes(
                        mediaMetaId: "eab0cabf-3c77-4a8e-91fe-5b2006667777")),
              ],
              isMedicalRecordsShared: '',
              isRefunded: '',
              lastModifiedBy: '',
              location: 'Coimbatore',
              patientId: '',
              plannedEndDateTime: '',
              plannedStartDateTime: '',
              sharedMedicalRecordsId: '',
              slotNumber: '5',
              specialization: '')
        ])));
