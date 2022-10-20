library fhb_parmeters;

import '../telehealth/features/appointments/view/appointments.dart';

const String strStatus = 'status';
const String strSuccess = 'isSuccess';
const String strMessage = 'message';
const String strResponse = 'response';
const String strData = 'data';
const String strUserInfo = 'userInfo';
const String strId = 'id';
const String strEmail = 'email';
const String strCountryCode = 'countryCode';
const String strPhoneNumber = 'phoneNumber';
const String strGender = 'gender';
const String strGenderID = 'genderId';
const String strdob = 'dob';
const String strIstemper = 'isTempUser';
const String strIsEmailVerified = 'isEmailVerified';
const String strTransactionId = 'transactionId';
const String strCreationTime = 'creationTime';
const String strExpirationTime = 'expirationTime';
const String strCount = 'count';
const String strRoleName = 'roleName';
const String strRoleDescription = 'roleDescription';
const String strIsActive = 'isActive';
const String strCreatedOn = 'createdOn';
const String strLastModifiedOn = 'lastModifiedOn';

//parameters for doctors,hospital and laboratory

const String strAddressLine1 = 'addressLine1';
const String strAddressLine2 = 'addressLine2';
const String strWebsite = 'website';
const String strGoogleMapUrl = 'googleMapUrl';
const String strPhoneNumber1 = 'phoneNumber1';
const String strPhoneNumber2 = 'phoneNumber2';
const String strPhoneNumber3 = 'phoneNumber3';
const String strPhoneNumber4 = 'phoneNumber4';
const String strState = 'state';
const String strCity = 'city';
const String strSpecilization = 'specialization';
const String strIsUserDefined = 'isUserDefined';
const String strDescription = 'description';
const String strCreatedBy = 'createdBy';
const String strFirstName = 'firstName';
const String strLastName = 'lastName';

//for bookmark
const String strMediaMetaIds = 'mediaMetaIds';
const String strIsBookmarked = 'isBookmarked';

//for database table country and unitmeasurement
const String strbpSPUnit = 'bpSPUnit';
const String strbpDPUnit = 'bpDPUnit';
const String strbpPulseUnit = 'bpPulseUnit';
const String strglucometerUnit = 'glucometerUnit';
const String strpoOxySatUnit = 'poOxySatUnit';
const String strpoPulseUnit = 'poPulseUnit';
const String strtempUnit = 'tempUnit';
const String strweightUnit = 'weightUnit';

const String strUnits = 'units';
const String strminValue = 'minValue';
const String strmaxValue = 'maxValue';
const String strRange = 'range';

const String strmediaMasterIds = 'mediaMasterIds';

//for hospital data
const String strLatitude = 'latitude';
const String strLongitute = 'longitude';
const String strLogo = 'logo';
const String strLogothumbnail = 'logoThumbnail';
const String strZipcode = 'zipCode';
const String strBranch = 'branch';

//for authentication
const String strLastLoggedIn = 'lastLoggedIn';
const String strAuthToken = 'authToken';

//for maya
const String strIsMayaSaid = 'isMayaSaid';
const String strText = 'text';
const String strImageUrl = 'imageUrl';
const String strTimeStamp = 'timeStamp';
const String strName = 'name';

//speechmodel
const String strSender = 'sender';
const String strSenderName = 'Name';
const String strSource = 'source';
const String strSessionId = 'sessionId';
const String strRelationShipId = 'relationshipId';
const String strConversationFlag = 'conversationFlag';
const String strReceiptId = 'recipient_id';
const String strEndOfConv = 'endOfConv';
const String strSpeechImageURL = 'imageURL';
const String strLanguage = 'lang';
const String strtimezone = 'timezone';
const String KIOSK_data = 'kiosk_data';
const String KIOSK_task = 'task';
const String KIOSK_messages = 'messages';
const String KIOSK_remind = 'remind';
const String KIOSK_read = 'read';
const String KIOSK_appointment_avail = 'availability';
const String KIOSK_eid = 'eid';
const String KIOSK_action = 'Action';
const String KIOSK_activityName = 'ActivityName';
const String KIOSK_message = 'Message';
const String KIOSK_message_api = 'message';
const String KIOSK_isSheela = 'isSheela';
const String strSearchUrl = 'searchURL';
const String strButtons = 'buttons';
const String strVideoLinks = 'videoLinks';
const String strPlatforType = 'device_type';
const String strScreen = 'screen';
const String strProviderMsg = 'provider_msg';
const String strRedirect = 'redirect';
const String strEnableMic = 'enable_mic';
const String strDashboard = 'dashboard';
const String strSheela = 'sheela';
const String strsingleuse = 'singleuse';
const String strisActionDone = 'isActionDone';
const String strRedirectTo = 'redirectTo';

// sheel lex
const String strBotaliasid = 'botAliasId';
const String strBotId = 'botId';
const String strLocaleId = 'localeId';
const String strTextLex = 'text';
const String strSessionIdLex = 'sessionId';
const String strSessionState = 'sessionState';
const String strSessionAttributes = 'sessionAttributes';
const String strAuthTokenLex = 'authToken';
const String strUserId = 'userId';
const String strEndPoint = 'endPoint';
const String strRelationshipId = 'relationshipId';
const String strUserName = 'name';
const String strSourceLex = 'source';
const String strTimeZone = 'timeZone';
const String strTimeZoneOffset = 'timeZoneOffset';
const String strLocalDateTime = 'localDateTime';
const String strQURHOME_LEX = 'QURHOME_LEX';

const String qr_sheela_lex = 'sheela/wrapper';

//for category
const String strCategoryName = 'categoryName';
const String strCategoryDesc = 'categoryDescription';
const String strIsDisplay = 'isDisplay';
const String strIsCreate = 'isCreate';
const String strIsRead = 'isRead';
const String strIsEdit = 'isEdit';
const String strIsDelete = 'isDelete';

//for digitRecognisition
const String strParameters = 'parameter';
const String strUnit = 'unit';
const String strValues = 'values';
const String strmediaMetaId = 'mediaMetaId';
const String strmediaMasterId = 'mediaMasterId';
const String strDeviceMeasurements = 'deviceMeasurements';
const String strmediaMetaID = 'mediaMetaID';

//for healthRecords
const String strmediaMetaInfo = 'mediaMetaInfo';
const String strmetaTypeId = 'metaTypeId';
const String struserId = 'userId';
const String strIsCaregiver = 'isCaregiver';
const String strDeliveredDateTime = 'deliveredDateTime';
const String strisFromCareCoordinator = 'isFromCareCoordinator';
const String strmetaInfo = 'metaInfo';
const String strisDraft = 'isDraft';
const String strcreatedByUser = 'createdByUser';
const String strcategoryInfo = 'categoryInfo';
const String strdateOfVisit = 'dateOfVisit';
const String strdeviceReadings = 'deviceReadings';
const String strdoctor = 'doctor';
const String strfileName = 'fileName';
const String strhasVoiceNotes = 'hasVoiceNotes';
const String strmediaTypeInfo = 'mediaTypeInfo';
const String strmemoText = 'memoText';
const String strmemoTextRaw = 'memoTextRaw';
const String strsourceName = 'sourceName';
const String strlaboratory = 'laboratory';
const String strhospital = 'hospital';
const String strdateOfExpiry = 'dateOfExpiry';
const String stridType = 'idType';
const String strurl = 'url';
const String strlocalid = 'localid';
const String strvalue = 'value';
const String strunit = 'unit';
const String strcategoryId = 'categoryId';
const String strisAITranscription = 'isAITranscription';
const String strisManualTranscription = 'isManualTranscription';
const String strLocal_Lab_Id = 'Local_Lab_Id';
const String strLocal_Doctor_Id = 'Local_Doctor_Id';
const String strLocal_Hospital_Id = 'Local_Hospital_Id';
const String strPlanSubscriptionInfoId = 'planSubscriptionInfoId';

//for profile
const String strlastName = 'lastName';
const String strfirstName = 'firstName';
const String strmiddleName = 'middleName';
const String strtype = 'type';
const String strgcmtype = 'gcm.notification.type';

const String strgeneralInfo = 'generalInfo';
const String strisDefault = 'isDefault';
const String strprofilePic = 'profilePic';
const String strprofilePicThumbnail = 'profilePicThumbnail';
const String strisVirtualUser = 'isVirtualUser';
const String strbloodGroup = 'bloodGroup';
const String strdateOfBirth = 'dateOfBirth';
const String strisTokenRefresh = 'isTokenRefresh';
const String strisEmailVerified = 'isEmailVerified';
const String strqualifiedFullName = 'qualifiedFullName';
const String strnickName = 'nickName';
const String strcustomRoleId = 'customRoleId';
const String strroleName = 'roleName';
const String strmodeOfShare = 'modeOfShare';
const String strprofileData = 'profileData';
const String strlinkedData = 'linkedData';
const String strsharedbyme = 'sharedbyme';
const String strsharedToMe = 'sharedToMe';
const String strvirtualUserParent = 'virtualUserParent';
const String strMappedDoctorId = 'mappedDoctorId';
const String strProfilePicThumbnailURL = 'profilePicThumbnailURL';
const String strinput = 'input';
const String strtext = 'text';
const String strvoice = 'voice';
const String strlanguageCode = 'languageCode';
const String straudioConfig = 'audioConfig';
const String strisAudioFile = 'isAudioFile';
const String strMP3 = 'MP3';

const String ssmlGender = 'ssmlGender';
const String Female = 'FEMALE';
const String regimentInput = 'q';
const String regimentToTranslateInput = 'toTranslateContent';
const String regimentSource = 'source';
const String regimentTarget = 'target';
const String regimentFormat = 'format';
const String regimentAudioEncoding = 'audioEncoding';
const String regimentIsAudioFile = 'isAudioFile';

const String audioEncoding = 'audioEncoding';
const String strmedicalPreferences = 'medicalPreferences';
const String strpreferences = 'preferences';
const String strdoctorIds = 'doctorIds';
const String strlaboratoryIds = 'laboratoryIds';
const String strhospitalIds = 'hospitalIds';

const String strdoctorPatientMappingId = 'doctorPatientMappingId';
const String strisVisible = 'isVisible';
const String strlastModifiedBy = 'lastModifiedBy';

const String strDate = 'date';
const String strDoctorId = 'doctorId';

const String strSourceId = 'sourceId';
const String strEntityId = 'entityId';
const String strRoleId = 'roleId';
const String strSrcIdVal = 'e13019a4-1446-441b-8af1-72c40c725548';
const String strEntityIdVal = '28858877-4710-4dd3-899f-0efe0e9255db';
const String strRoleIdVal = '285bbe41-3030-4b0e-b914-00e404a77032';
const String strotp = 'otp';
const String strOperation = 'operation';
const String strverification = 'verificationCode';
const String strfileType = 'fileType';
const String stroid = 'oid';
const String strpassword = 'password';

const String strhosname = 'hosname';
const String strdocname = 'docname';
const String strappdate = 'appdate';
const String strapptime = 'apptime';
const String strreason = 'reason';

const String strtitle = 'title';
const String strnotes = 'notes';
const String strdate = 'date';
const String strtime = 'time';
const String strinterval = 'interval';

const String strSections = 'sections';
const String strfile = 'file';
const String strIsClose = 'isClose';

const String strAuthtoken = 'authToken';
const String strSourceName = 'sourceName';
const String strMemoRawTxtVal = 'memoTextRaw';

const String strStartDate = 'startDateTime';
const String strEndDate = 'endDateTime';

const String strTerms = 'terms';
const String strplaceId = 'placeId';
const String strplace_id = 'place_id';
const String strformatted_address = 'formatted_address';
const String strformatted_phone_number = 'formatted_phone_number';
const String strrating = 'rating';
const String strvicinity = 'vicinity';
const String strgeometry = 'geometry';
const String strlocation = 'location';
const String strlat = 'lat';
const String strlng = 'lng';
const String strpredictions = 'predictions';
const String dataResult = 'result';
const String strresults = 'results';

const String strentityCode = 'entityCode';
const String strgoFhbCode = 'goFhbCode';
const String strlabPatientMappingId = 'labPatientMappingId';
const String strcityId = 'cityId';
const String strstateId = 'stateId';
const String strpinCode = 'pinCode';
const String strisTelehealthEnabled = 'isTelehealthEnabled';
const String strisMCIVerified = 'isMCIVerified';
const String strlanguages = 'languages';
const String strprofessionalDetails = 'professionalDetails';
const String strfees = 'fees';
const String strlanguageId = 'languageId';
const String straboutMe = 'aboutMe';
const String strqualificationInfo = 'qualificationInfo';
const String strmedicalCouncilInfo = 'medicalCouncilInfo';
const String strspecialty = 'specialty';
const String strclinicName = 'clinicName';
const String strpincode = 'pincode';

const String strdegree = 'degree';
const String struniversity = 'university';
const String strconsulting = 'consulting';
const String strfollowup = 'followup';
const String strcancellation = 'cancellation';
const String strdays = 'days';
const String strfee = 'fee';
const String strfollowupIn = 'followupIn';
const String strfollowupValue = 'followupValue';
const String strfollowupType = 'followupType';
const String strdestinationId = 'destinationId';
const String strFamilyProfile = 'memberAdditionReceiverNotification';

//Booking Confirm
const String self = 'Self';
const String theAppointmentIsFor = 'The Appointment is for';
const String thePlanIsFor = 'The Plan is for';

const String dateAndTime = 'Date & Time';
const String confirmDetails = 'Confirmation Details';
const String preConsultingDetails = 'Pre Consulting Details';
const String addNotes = 'Add Notes';
const String addVoice = 'Add Voice';
const String records = 'Records';
const String deviceReading = 'Device Readings';
const String payNow = 'Pay Now';
const String slotsAreNotAvailable = 'Slot not available in this date';
const String bookNow = 'Book Now';
const String redirectedToPaymentMessage =
    'You are being re-directed to a secured payment site';
const String cancellationAppointmentConfirmation =
    'Are you sure you want to cancel this appointment';
const String ok = 'Ok';
const String yes = 'Yes';
const String no = 'No';
const String btn_switch = 'Switch';
const String btn_decline = 'Decline';
const String appointmentCreatedMessage =
    'Created a new appointment successfully.';
const String someWentWrong = 'Booking appointment failed.. Some went wrong!';
const String checkSlots = 'Checking available slots..';
const String selectSlotsMsg =
    'Please select your time slot before you book an appointment';
const String noUrl = 'Something went wrong ..please try again..';
const String noAddress =
    'Please fill your address details in your profile before you book an appointment';

const String no_addr1_zip =
    'Address line 1 and Zipcode is required to proceed booking the appointment';
const String noAddress1 =
    'Address line 1 is required to proceed booking the appointment';

const String noZipcode =
    'Zipcode is required to proceed booking the appointment';
const String noGender =
    'Please fill your gender and address details in your profile before you book an appointment';
const String noDOB =
    'Please fill your date of birth in your profile before you book an appointment';
const String noHeight =
    'Please fill your height in your profile before you book an appointment';
const String noWeight =
    'Please fill your weight in your profile before you book an appointment';
const String noAdditionalInfo =
    'Please fill your height & weight in your profile before you book an appointment';

const String noAddressFamily =
    'Please fill your address details in your selected family member before you book an appointment';
const String noGenderFamily =
    'Please fill your gender and address details in your selected family member before you book an appointment';
const String noDOBFamily =
    'Please fill your date of birth in your selected family member before you book an appointment';
const String noHeightFamily =
    'Please fill your height in your selected family member before you book an appointment';
const String noWeightFamily =
    'Please fill your weight in your selected family member before you book an appointment';
const String noAdditionalInfoFamily =
    'Please fill your height & weight in your selected family member before you book an appointment';

const String CLEAR_CART_MSG = 'Are you sure you want to remove all plans?';

//Payment
const String PAYMENT_STATUS = 'payment_status';
const String RAZOR_PAYMENT_STATUS = 'razorpay_payment_link_status';
const String CREDIT = 'Credit';
const String PAID = 'paid';
const String PAYMENT_ID = 'payment_id';
const String RAZOR_PAYMENT_ID = 'razorpay_payment_id';
const String PAYMENT_REQ_ID = 'payment_request_id';
const String RAZOR_PAYMENT_REQ_ID = 'razorpay_payment_link_id';
const String SIGNATURE = 'razorpay_signature';
const String CHECK_URL = 'EFHB_Loader.html';
const String TITLE_BAR = 'Payment';
const String REPORT_PAGE = 'Report Page';
const String PAYSUC = 'PAYSUC';
const String STATUS_FAILED = 'status=failed';
const String PAYCREDIT = 'Credit';
const String PAYCAPTURED = 'captured';
const String PAYMENT_SUCCESS_PNG = 'assets/payment/success_tick.png';
const String PAYMENT_FAILURE_PNG = 'assets/payment/failure.png';
const String PROFILE_PH = 'assets/user/profile_pic_ph.png';
const String PAYMENT_SUCCESS_MSG = 'Payment Successful';
const String PAYMENT_FAILURE_MSG = 'Payment Failed';
const String APPOINTMENT_CONFIRM = 'Your appointment is now confirmed';
const String PLAN_CONFIRM = 'Your plan subscription is now confirmed';
const String UNABLE_PROCESS = 'We unable to reach your process..';
const String PAYMENT_FAILURE_CONTENT =
    'Note: If any amount is deducted, we will do an automatic refund. Your bank might take 7 to 8 days to process it and reflect that in your account.';

const String strSourceCode = 'sourceCode';
const String strEntityCode = 'entityCode';
const String strRoleCode = 'roleCode';
const String strprofilePicThumbnailURL = 'profilePicThumbnailURL';

//parameters for device Integration

const String strBPTitle = 'BP Readings';
const String strGLTitle = 'Glucose Readings';
const String strOxyTitle = 'Pulse Oximeter';
const String strWgTitle = 'Weight Measurement';
const String strTmpTitle = 'Temperature Readings';
const String strLatestTitle = 'Latest Readings';
const String strDateYMD = 'yMMMd';
const String strTimeHMS = 'Hms';
const String strTimeHM = 'hh:mm a';

const String strsourceGoogle = 'Google Fit';
const String strsourceSheela = 'SHEELA';
const String strsourceHK = 'Apple Health';
const String strsourceCARGIVER = 'CAREGIVER';
const String strdevicesourceName = 'sourceType';
const String strdeviceType = 'deviceType';
const String strdeviceDataType = 'deviceDataType';
const String strRawData = 'rawHealthData';

const String strsyncStartDate = 'startDateTime';
const String strsyncEndDate = 'endDateTime';
const String strlocalTime = 'localTime';
const String strlastSyncDateTime = 'lastSyncDateTime';
const String strStartTimeStamp = 'startDateTime';
const String strEndTimeStamp = 'endDateTime';
const String is_Success = 'isSuccess';
const String strsourcetype = 'sourceType';
const String strStartTimeStampNano = 'startDateTimeNano';
const String strEndTimeStampNano = 'endDateTimeNano';

//Data Params for device readings
//DataCollections
const String strBloodPressureCollection = 'bloodPressureCollection';
const String strBloodGlucoseCollection = 'bloodGlucoseCollection';
const String strBodyTemperatureCollection = 'bodyTemperatureCollection';
const String strHearRateCollection = 'heartRateCollection';
const String strOxygenCollection = 'oxygenSaturationCollection';
const String strWeightCollection = 'bodyWeightCollection';

//BP
const String strBPMonitor = 'BP Monitor';
const String strDataTypeBP = 'Blood Pressure';
const String strParamSystolic = 'systolic';
const String strParamDiastolic = 'diastolic';
const String strParamDeviceHealthRecord = 'deviceHealthRecord';
const String strParamAverageAsOfNow = 'averageAsOfNow';
//Glucose
const String strGlucometer = 'Glucometer';
const String strGlusoceLevel = 'Blood Glucose';
const String strParamBGLevel = 'bloodGlucoseLevel';
const String strParamBGUnit = 'bgUnit';
const String strMGDL = 'mg/dL';
const String strParamBGMealContext = 'mealContext';
const String strParamBGMealType = 'mealType';
//Temperature
const String strThermometer = 'Thermometer';
const String strTemperature = 'Body Temperature';
const String strParamTemp = 'temperature';
const String strParamTempUnit = 'temperatureUnit';
const String strParamUnitCelsius = 'Celsius';
const String strParamUnitFarenheit = 'Fahrenheit';
//Weight
const String strWeighingScale = 'Weighing Scale';
const String strWeight = 'Weight';
const String strParamWeight = 'weight';
const String strParamWeightUnit = 'weightUnit';
const String strValueWeightUnit = 'kg';

//HeartRate
const String strHeartRate = 'Heart Rate';
const String strParamHeartRate = 'bpm';
//PulseOxymeter
const String strOxymeter = 'Pulse Oximeter';
const String strOxgenSaturation = 'Oxygen Saturation';
const String strParamOxygen = 'oxygenSaturation';
//Google Fit Params

// Google Fit
const String gfWeight = 'com.google.weight';
const String gfHeartRate = 'com.google.heart_rate.bpm';
const String gfBloodPressure = 'com.google.blood_pressure';
const String gfBloodGlucose = 'com.google.blood_glucose';
const String gfOxygenSaturation = 'com.google.oxygen_saturation';
const String gfBodyTemperature = 'google.body.temperature';

const String gfWeightSource =
    'derived:com.google.weight:com.google.android.gms:merge_weight';
const String gfHeartRateSource =
    'derived:com.google.heart_rate.bpm:com.google.android.gms:merge_heart_rate_bpm';
const String gfBloodPressureSource =
    'derived:com.google.blood_pressure:com.google.android.gms:merged';
const String gfBloodGlucoseSource =
    'derived:com.google.blood_glucose:com.google.android.gms:merged';
const String gfOxygenSaturationSource =
    'derived:com.google.oxygen_saturation:com.google.android.gms:merged';
const String gfBodyTemperatureSource =
    'derived:com.google.body.temperature:com.google.android.gms:merged';

List<String> dataTypes = [
  gfWeight,
  gfHeartRate,
  gfBloodPressure,
  gfBloodGlucose,
  gfOxygenSaturation,
  gfBodyTemperature
];
List<String> dataSource = [
  gfWeightSource,
  gfHeartRateSource,
  gfBloodPressureSource,
  gfBloodGlucoseSource,
  gfOxygenSaturationSource,
  gfBodyTemperatureSource
];
Map<String, String> dataSourceID = Map.fromIterables(dataTypes, dataSource);

//Google Fit Scopes
const String gfscopeBodyRead =
    'https://www.googleapis.com/auth/fitness.body.read';
const String gfscopepressureRead =
    'https://www.googleapis.com/auth/fitness.blood_pressure.read';
const String gfscopetempRead =
    'https://www.googleapis.com/auth/fitness.body_temperature.read';
const String gfscopesaturationRead =
    'https://www.googleapis.com/auth/fitness.oxygen_saturation.read';
const String gfscopeglucoseRead =
    'https://www.googleapis.com/auth/fitness.blood_glucose.read';

const String gfAggregateURL =
    'https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate';

// Google Fit Response variables
const String gfbucket = 'bucket';
const String gfstartTimeMillis = 'startTimeMillis';
const String gfendTimeMillis = 'endTimeMillis';
const String gfdataset = 'dataset';
const String gfdataSourceId = 'dataSourceId';
const String gfpoint = 'point';
const String gfstartTimeNanos = 'startTimeNanos';
const String gforiginDataSourceId = 'originDataSourceId';
const String gfendTimeNanos = 'endTimeNanos';
const String gfvalue = 'value';
const String gfdataTypeName = 'dataTypeName';
const String gfmapVal = 'mapVal';
const String gffpVal = 'fpVal';

//HealthKit Response variables
const String hktWeightUnit = 'KILOGRAMS';
const String hktHeartRateUnit = 'BEATS_PER_MINUTE';
const String hktGlucoseUnit = 'MILLIGRAM_PER_DECILITER';
const String hktTemperatureUnit1 = 'DEGREE_CELSIUS';
const String hktTemperatureUnit2 = 'FARENHEIT';

//myFHB response variables
const String strBGlucose = 'bloodGlucose';
const String strBP = 'bloodPressure';
const String strTemp = 'bodyTemperature';
const String strWgt = 'bodyWeight';
const String strHRate = 'heartRate';
const String strOxygen = 'oxygenSaturation';
const String strentities = 'entities';
const String strUser = 'user';

// For Telehealth Appointments
const String strHistory = 'history';
const String strUpcoming = 'upcoming';
const String strAppointmentId = 'appointmentId';
const String strHealthRecord = 'healthRecord';
const String strPlannedStartDateTime = 'plannedStartDateTime';
const String strPlannedEndDateTime = 'plannedEndDateTime';
const String strSlotNumber = 'slotNumber';
const String strIsRefunded = 'isRefunded';
const String strBookingID = 'bookingID';
const String strSharedMedicalRecordsId = 'sharedMedicalRecordsId';
const String strIsMedicalRecordsShared = 'isMedicalRecordsShared';
const String strDoctorPic = 'doctorPic';
const String doctorPicture = 'doctorPicture';
const String strDoctorName = 'doctorName';
const String strDoctorSessionId = 'doctorSessionId';
const String strPatientId = 'patientId';
const String strActualStartDateTime = 'actualStartDateTime';
const String strActualEndDateTime = 'actualEndDateTime';
const String strFollowupDate = 'followupDate';
const String strFollowupFee = 'followupFee';
const String strPaymentMediaMetaId = 'paymentMediaMetaId';
const String strRefundMediaMetaId = 'refundMediaMetaId';
const String strPrescription = 'prescription';
const String strVoice = 'voice';
const String strrx = 'rx';
const String strothers = 'others';
const String strCreatedFor = 'createdFor';
const String strStatusId = 'statusId';
const String strIsFollowUpFee = 'isFollowUpFee';
const String strAppointmentInfo = 'appointmentInfo';
const String strPlannedFollowupDate = 'plannedFollowupDate';
const String strPaymentInfo = 'paymentInfo';

//Add Family User Info
const String make_a_choice = 'Make a Choice!';

// Video call
const String GCMUserId = 'gcm.notification.userId';
const String strgcmAppointmentId = 'gcm.notification.appointmentId';
const String gcmExternalLink = 'gcm.notification.externalLink';
const String gcmClaimId = 'gcm.notification.claimId';
const String gcmtemplateName = 'gcm.notification.templateName';
const String gcmpatientPhoneNumber = 'gcm.notification.patientPhoneNumber';
const String gcmverificationCode = 'gcm.notification.verificationCode';
const String gcmcaregiverReceiver = 'gcm.notification.caregiverReceiver';
const String gcmcaregiverRequestor = 'gcm.notification.caregiverRequestor';
const String notificationListId = 'notificationListId';

const String gcmplanId = 'gcm.notification.planId';
const String gcmpatientName = 'gcm.notification.patientName';

const String gcmredirectTo = 'gcm.notification.redirectTo';
const String externalLink = 'externalLink';
const String onresume = 'OnResume New';
const String onlaunch = 'OnLaunch New';
const String username = 'username';
const String meeting_id = 'meeting_id';
const String doctorId = 'doctorId';
const String aps = 'aps';
const String appointment = 'appointment';
const String ack = 'ack';
const String alert = 'alert';
const String title = 'title';
const String callType = 'callType';
const String body = 'body';
const String sound = 'sound';
const String PROP_EVEID = 'eventId';
const String gcmEventId = 'gcm.notification.eventId';
const String senderId = 'senderId';
const String senderName = 'senderName';
const String senderProfilePic = 'senderProfilePic';
const String PROP_RAWTITLE = 'rawTitle';
const String PROP_RAWBODY = 'rawBody';
const String custom_sound = 'Custom_Sound';
const String channel_id = 'channel id';
const String channel_name = 'channel NAME';
const String channel_descrip = 'channel DESCRIPTION';
const String launcher = '@mipmap/ic_launcher';
const String data = 'data';
const String call = 'call';
const String doctorCancellation = 'DoctorCancellation';
const String doctorRescheduling = 'DoctorRescheduling';
const String reschedule = 'Reschedule';
const String cancel = 'Cancel';
const String templateName = 'templateName';
const String redirectTo = 'redirectTo';
const String accept = 'Accept';
const String reject = 'Reject';
const String viewMember = 'View Member';
const String communicationSetting = 'Communication Setting';
const String CARE_COORDINATOR_USER_ID = "careCoordinatorUserId";
const String CARE_GIVER_NAME = "careGiverName";
const String ACTIVITY_TIME = "activityTime";
const String ACTIVITY_NAME = "activityName";

const String decline = 'Decline';
const String meetingId = 'meeting_id';
const String notification = 'notification';
const String familyMemberCaregiverRequest = 'familyMemberCaregiverRequest';
const String associationNotificationToCaregiver =
    'associationNotificationToCaregiver';
const String strCaregiverAppointmentPayment = 'caregiverAppointmentPayment';
const String strCaregiverNotifyPlanSubscription =
    'caregiverNotifyPlanSubscription';
const String strQurbookServiceRequestStatusUpdate =
    'qurbookServiceRequestStatusUpdate';

const String patientPhoneNumber = 'patientPhoneNumber';
const String uid = 'uid';
const String verificationCode = 'verificationCode';
const String caregiverReceiver = 'caregiverReceiver';
const String caregiverRequestor = 'caregiverRequestor';
const String token = 'Token';
const String healthRecordMetaIds = 'healthRecordMetaIds';
const String ongoing_channel = 'ongoing_ns.channel';
const String startOnGoingNS = 'startOnGoingNS';
const String notifyCaregiverForMedicalRecord =
    'notifyCaregiverForMedicalRecord';
const String mode = 'mode';
const String start = 'start';
const String stop = 'stop';
const String appid_missing =
    'APP_ID missing, please provide your APP_ID in settings.dart';
const String agora_not_starting = 'Agora Engine is not starting';
const String exit_call = 'Do you want exit from call?';
const String cancel_appointment = 'Are you want cancel Appointment?';
const String warning = 'warning!';
const String Yes = 'Yes';
const String No = 'No';
const String patientName = 'patientName';
const String patientPicture = 'patientPicture';

const String doctorName = 'doctorName';
const String planName = 'planName';
const String healthOrganizationName = 'healthOrganizationName';
const String healthOrganizationLogo = 'healthOrganizationLogo';
const String userPlanStartDate = 'userPlanStartDate';
const String userPlanEndDate = 'userPlanEndDate';
const String UserPlanPackageAssociation = 'UserPlanPackageAssociation';

const String id = 'doctorId';
const String healthOrganization = 'healthOrganization';

//for the new models

const String strIsSuccess = 'isSuccess';
const String strResult = 'result';

const String strIsAiTranscription = 'isAiTranscription';
const String strHealthRecordCategory = 'healthRecordCategory';

//chat
const String NICK_NAME = 'nickname';
const String PHOTO_URL = 'photoUrl';
const String ID = 'id';
const String CREATED_AT = 'createdAt';
const String CHATTING_WITH = 'chattingWith';
const String DISPLAY_NAME = 'display_name';
const String PROFILE_IMAGE = 'profile_image';
const String ABOUT_ME = 'aboutMe';
const String FETCH_LOG = 'FETCH_LOG';

const String USERS = 'users';
const String chat = 'chat';
const String isWeb = 'isWeb';
const String escalateToCareCoordinatorToRegimen =
    'escalateToCareCoordinatorToRegimen';

const String planId = 'planId';
const String myCartDetails = 'mycartdetails';
const String myPlanDetails = 'myplandetails';
const String claimList = 'claimList';
const String claimId = 'claimId';
//appointment
const String strIsFollowUp_C = 'isFollowUp';
const String strDoctorSession = 'doctorSession';
const String strBookedFor = 'bookedFor';
const String strBookedBy = 'bookedBy';
const String strBookingId_S = 'bookingId';
const String strIsFollowUp_S = 'isFollowup';
const String strIsHealthRecordShared = 'isHealthRecordShared';
const String strPayment = 'payment';
const String strPaymentGateWayDetail = 'paymentGatewayDetail';

const String strReferenceId = 'doctorReferenceId';
const String strhealthRecordCategory = 'healthRecordCategory';
const String strhealthRecordType = 'healthRecordType';
const String strDoctorReferenceId = 'doctorReferenceId';
const String strHealthOrganizationId = 'healthOrganizationId';
const String strHealthOrganizationReferenceId = 'healthOrganizationReferenceId';
const String strpatient = 'patient';

const String strHealthOrganizationName = 'healthOrganizationName';
const String strHealthRecordMetaId = 'healthRecordMetaId';
const String strDestinationUserId = 'destinationUserId';
const String strSourceUserId = 'sourceUserId';

const String errAssociateRecords =
    'Error while creating shared record details.';

const String strMetaData = 'metadata';
const String strMultipart = 'multipart/form-data';

const String qurHealthLogo = 'assets/launcher/myfhb.png';

const String errNoRecordsSelected = 'No Records Selected';

const String strCopyVitalsMsg =
    'Matching activity is found in your regimen, do you want to copy the values?';
const String strglucose = 'SPO2';
const String strBloodSugar = 'BloodSugar';
