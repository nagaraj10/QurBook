//Labels
const String addNoteHint = 'Add notes here';
const String prescribeButtonText = 'Prescribe';
const String createNewButtonText = 'Create New';
const String duplicateButtonText = 'Duplicate';
const String medicineNameHint = 'Medicine Name *';
const String addMedicineNoteHint = 'Add medicine notes here';
const String medicineQuantityHint = 'Qty';
const String numberOfDaysHint = 'Days';
const String scheduleOptionOne = '0';
const String scheduleOptionTwo = '1';
const String scheduleOptionThree = '0.5';
const String beforeFoodSwitchText = 'BF';
const String afterFoodSwitchText = 'AF';
const String testPatientName = 'Ravindran Perumal';
const String testPatientID = '#AD5729488';
const String prescription_List_Const = 'Prescription List';
const String PRESCRIPTION_PREFIX = 'E Prescription';
const String defaultDosageValue = '0';
const String emptyTextPlaceHolder = '';
const String prescriptionPatientID = '2365a196-cac5-416b-bc05-8ecb815201e1';
const String prescriptionDateFormat = 'MMM d, yyyy';
const String EMPTY_MED_NAME = 'Please enter medicine name';
const String EMPTY_DAYS_FIELD = 'Please enter number of days';
const String EMPTY_QTY_FIELD = 'Please enter medicine quantity';
const String prescriptionName = 'Name';
const String prescriptionname = 'Vignesh';
const String prescriptionDate = 'Tue, 05 May, 2020';
const String prescriptionGender = 'Gender';
const String prescriptionHeight = 'Height';
const String prescriptionWeight = 'Weight';
const String prescriptiongender = 'Male';
const String prescriptionAge = 'Age';
const String prescriptionage = '';
const int static_zero = 0;
const String prescriptionMobile = 'Mobile Number';
const String prescriptionmobile = '+91 9924572231';
const String prescriptionNotes = 'Notes';
const String bfaf = 'BF/AF';
const String days = 'Days';
const String schedule = 'Schedule';
const String qty = 'Qty';
const String dateFormat = 'EEE, MMM d, ' 'yyyy';
const String FAILED_CREATION =
    "Prescription Creation Failed ..Please try again..";
const String FAILED_TO_FETCH = "Failed to Fetch";
const String idPresentMedicine = 'medicine present';
const String idNotPresentMedicine = 'no medicine';

// const String getActivePrescriptions =
//     'https://a32byh132v.vsolgmi.com/prescription/c99b732e-d630-4301-b3fa-e7c800b891b4/bde140db-0ffc-4be6-b4c0-5e44b9f54535';
//const String testActivePrescription =
//    'https://a32byh132v.vsolgmi.com/prescription/f430e882-cfe9-4957-8d0e-94d5c8b14d56/2365a196-cac5-416b-bc05-8ecb815201e1';
//const String testNewPrescription =
//    'https://a32byh132v.vsolgmi.com/prescription';
//String staticPatientID = '';

//Image
const String prescriptionImage = "assets/images/prescription/company_name.png";
const String prescriptionSignature =
    'assets/images/prescription/patient_sign.png';

//Url
//const String prescriptionEndPointAPI =
//    'https://a32byh132v.vsolgmi.com/prescription';
//const String getActivePrescriptionsBaseURL =
//    'https://a32byh132v.vsolgmi.com/prescription/';

//Query
const String qr_prescription = 'prescription';
const String qr_slash = '/';

const String qr_fetch_medicine = 'medicine?name=';
const String auth_token = "auth_token";
const String doc_Id = "doctor_id";
const String content_type = 'Content-type';
const String multi_part_form_data = 'multipart/form-data';
const String application_json = 'application/json';
const String authorization = 'Authorization';
const String error =
    "Error occured while Communication with Server with StatusCode";
const String duplicateMessage = 'Please remove the duplicate medicines';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
