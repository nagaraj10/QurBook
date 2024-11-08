const String qr_MedicallPrefernce = 'medicalPreferences||';
const String qy_entitylab = 'entity=laboratoryIds|';
const String qr_entityHospital = 'entity=hospitalIds|';
const String qr_entityDoctor = 'entity=doctorIds|';
const String qr_add = 'add=';
const String qr_negation = '|';
const String qr_default = '|setDefault=';
const String qr_Userprofile = 'userProfiles/';
const String qr_sections = '?section=';
const String qr_mediameta = 'mediameta/';
const String qr_updatebookmark = 'updatebookmark/';
const String qr_users = 'users/';
const String qr_search = 'search/';
const String qr_Feedback = 'Feedback';

const String qr_healthRecords = 'healthRecords?';
const String qr_keyword = 'keyword=';
const String qr_picture = 'myconnection?isOriginalPicRequired=false';
const String qr_doctors = 'doctors/';
const String qr_profilePic = '/getprofilepic';
const String qr_customRole = 'reference-data?search-name=Relationship';
const String qr_sort = '?sortBy=roleName.asc&limit=50';
const String qr_userlinking = 'user-relationship';
const String qr_userDelinking = 'userDelinking/';
const String qr_getMediaData = 'getmediameta/';
const String qr_slash = '/';
const String qr_categories = 'categories/';
const String qr_sortCateories = '?sortBy=categoryName.asc&offset=0&limit=10';
const String qr_medicalPreferences = 'medicalPreferences';
const String qr_doctorpatientmapping = 'doctorpatientmapping/';
const String qr_updateDefaultProvider = 'updateDefaultProvider';
const String qr_isOriginalPicRequired = 'isOriginalPicRequired=false';
const String qr_isOriginalPicRequiredTrue = 'isOriginalPicRequired=true';
const String qr_language =
    'reference-data?search-name=Language&patient-lang=true';
const String qr_BLEDataUpload = 'device-data/kiosk/send-device-data';
const String qr_sendVerificationMail = '/sendVerificationMail';
const String qr_sortByQ = '?sortBy=';
const String qr_getCareCoordinatorId = 'qurplan-node-mysql/get-patient-carers/';
const String qr_getSOSAgentNumber = 'user/fetch-sos-exophone-info';
const String qr_messaging = 'messaging';
const String qr_triggerSOSMissedCallNotification =
    'messaging/sos-missed-call-notification';
const String qr_triggerMissedCallNotification =
    'messaging/trigger-missed-call-notification';
const String qr_callAppointmentUpdate = 'appointment/update?type=';
const String qr_nonAppointmentUrl = 'call-log/non-appointment-call';
const String qr_callLog = 'call-log/sos';
const String qr_startRecordCallLog = 'sos/call/record/start';
const String qr_stopRecordCallLog = 'sos/call/record/stop';
const String qr_meetingId = 'meetingId';
const String qr_UID = 'uid';
const String qr_resourceId = 'resourceId';
const String qr_sid = 'sid';
const String qr_callLogId = 'callLogId';
const String qr_joinedUid = 'joinedUid';
const String qr_location = 'location';
const String patient_alert = 'incident-alert/cg-alert-list?patientId=';
const String page_no = '&page=1&size=1000';

const String qr_caregivername = 'caregiverName';
const String qr_caregiverid = 'id';
const String qr_caregiver_ok = 'incident-alert/caregiver-action?action=seen';
const String qr_caregiver_escalate =
    'incident-alert/caregiver-action?action=escalate';
const String escalate_add_comments =
    'track-user-activities/regimen-screen-activity';

//modified by parvathi
const String qr_doctorslot = 'doctorSlots/';
const String qr_availability = 'getAvailability';
const String qr_slot_date = '2020-07-21';
const String qr_docId_val = 'c99b732e-d630-4301-b3fa-e7c800b891b4';

const String qr_deletemedia = 'deletemeta/';
const String qr_deletemaster = 'deletemaster/';

const String qr_SearchBy = 'search?';
const String qr_DoctorSearchByFilters = 'dynamic-search?';
const String qr_sortBy = 'sortBy=';
const String qr_offset = 'offset=';
const String qr_limit = 'limit=';
const String qr_And = '&';
const String qr_name_asc = 'name.asc';
const String qr_hopitals = 'hospitals/';
const String qr_lab = 'laboratories/';

const String qr_rawMedia = 'getRawMedia/';

const String qr_generalInfo = 'generalInfo';
const String qr_gender = 'gender=';
const String qr_bloodgroup = 'bloodGroup=';
const String qr_dateOfBirth = 'dateOfBirth=';
const String qr_name = 'name=';
const String qr_firstName = 'firstName=';
const String qr_middleName = 'middleName=';
const String qr_lastname = 'lastName=';
const String qr_email = 'email=';
const String qr_DSlash = '||';
const String qr_OSlash = '|';
const String qr_StateId = 'stateId=';
const String qr_CityId = 'cityId=';
const String qr_AddressLine1 = 'addressLine1=';
const String qr_AddressLine2 = 'addressLine2=';
const String qr_pincode = 'pincode=';

const String qr_category_asc = 'categoryName.asc';
const String qr_getprofilepic = 'getprofilepic/';
const String qr_savedmedia = 'savemediameta/';
const String qr_ai = 'ai/';
const String qr_savehealth = 'saveHealthRecord/';
const String qr_mediamaster = 'mediamaster/';
const String qr_savedmediamaster = 'savemediamaster/';
const String qr_move = '/move';
const String qr_updatemediameta = 'updatemediameta/';
const String qr_mediaTypes = 'mediaTypes/';

const String qr_authentication = 'authentication';
const String qr_auth = 'auth';
const String qr_signin = 'signin';
const String qr_verifyotp = 'verifyotp';
const String qr_generateotp = 'generateOTP';
const String qr_signup = 'signup';
const String qr_signout = 'signout';
const String qr_verifymail = 'verifyMail';

const String qr_slotDate = 'date';
const String qr_doctorid = 'doctorId';
const String qr_getSlots = 'doctor/checkavailability';
const String qr_bookAppointment = 'appointment';
const String qr_update_payment = 'payment/update-payment-status/';
const String qr_update_payment_subscribe =
    'payment/plan-subscription-update-payment-status';
const String qr_medium = 'medium';
const String qr_clearIds = 'clearIds';
const String qr_created_by = 'createdBy';
const String qr_booked_for = 'bookedFor';
const String qr_doctor_session_id = 'doctorSessionId';
const String qr_schedule_date = 'scheduledDate';
const String qr_slot_number = 'slotNumber';
const String qr_is_medical_shared = 'isMedicalRecordsShared';
const String qr_is_followup = 'isFollowUp';
const String qr_health_record_ref = 'healthRecordReference';
const String qr_wallet_deduction_amount = 'walletDeductionAmount';
const String qr_parent_appointment = 'parentAppointment';
const String qr_is_csr_discount = 'isCsrDiscount';
const String qr_discountType = 'discountType';
const String qr_csr_discount = 'CSR_DISCOUNT';
const String qr_MEMBERSHIP_DISCOUNT = 'MEMBERSHIP_DISCOUNT';
const String qr_payment_id = 'paymentId';
const String qr_appoint_id = 'appointmentId';
const String qr_payment_order_id = 'paymentOrderId';
const String qr_payment_req_id = 'paymentRequestId';
const String qr_signature = 'signature';

const String qr_input = '?input=';
const String qr_key = 'key=';
const String qr_type = 'type=';
const String qr_placequery =
    'radius=500&language=en&components=country:IN&sessiontoken=';
const String qr_ques = '?';
const String qr_latlng = 'latlng=';
const String qr_placedid = 'place_id=';
const String qr_lang_ko = 'language=ko';
const String qr_sessiontoken = 'sessiontoken=';

const String qr_caregiver_family = '/caregiver-family';
const String qr_caregiver_user_id = '?caregiverUserId=';

const String qr_LastSync = 'latest-sync';
const String qr_LastMeasureSync = 'latest-measure-sync';
const String qr_DeviceInterval = 'device-interval';
const String qr_calendarType = '?calendarType=';
const String qr_DeviceInfo = 'device-health-record';
const String qr_User = 'user';
const String qr_LastSyncGF = '?source=Google Fit';
const String qr_LastSyncHK = '?source=Apple Health';

const String BOOKING_ID = 'bookingId';
const String BOOKING_ID_CAPS = 'bookingID';
const String META_IDS = 'mediaMetaIds';
const String INCLUDE_MEDIA = 'includeMedia';

const String qr_media_meta = 'mediameta/';
const String qr_get_media_master = '/getmediamaster/';

const String qr_userid = 'userId';
const String qr_mediaMetaId = 'mediaMetaId';
const String qr_sharerecord = 'share-record';
const String qr_shareToType = '?shareToType=';
const String qr_Doctor = 'doctor';

const String qr_myconnection = 'myconnection/';

const String qr_id = '?id=';
const String qr_user = 'user/';
const String qr_userId = 'userId=';
const String qr_section = '?section=';
const String qr_myOrders = 'my-orders';
const String qr_approve_caregiver = '/approve-caregiver';
const String qr_reject_caregiver = '/reject-caregiver';

const String qr_doctor = 'doctor/';
const String qr_SearchText = 'searchText=';
const String qr_include = 'include=';
const String qr_personal = 'personal';
const String qr_name_desc = 'desc';
const String qr_skip = 'skip=';
const String qr_reference_doctor = 'reference-doctor/';
const String qr_non_qurpro = 'non-qurpro-doctor';
const String qr_non_qurpro_hospital = 'non-qurpro-hospital';

const String qr_membership =
    'plan-subscription-info/membership-details?userId=';
const String qr_organizationid = '&healthOrganizationId=';
const String qr_expiry_claim_list =
    'plan-subscription-info/claim-expired-plans-list/';

const String qr_health_organization = 'health-organization/';
const String qr_health_Search = 'search/';

//queries for the asgard
const String qr_category = 'category';
const String qr_reference_value = 'reference-value/';
const String qr_data_codes = 'data-codes';

//for asgard mediType
const String qr_health_record_type = 'health-record-type';
const String qr_health_record = 'health-records/';
const String qr_filter = 'filter';
const String qr_delete_file = 'delete-file';

//for update profile new

const String qr_gender_p = 'gender';
const String qr_bloodgroup_p = 'bloodGroup';
const String qr_dateOfBirth_p = 'dateOfBirth';
const String qr_name_p = 'name';
const String qr_firstName_p = 'firstName';
const String qr_middleName_p = 'middleName';
const String qr_lastname_p = 'lastName';
const String qr_email_p = 'email';
const String qr_StateId_p = 'stateId';
const String qr_CityId_p = 'cityId';
const String qr_AddressLine1_p = 'addressLine1';
const String qr_AddressLine2_p = 'addressLine2';
const String qr_pincode_p = 'pincode';

const String qr_delink = 'de-link';
const String qr_bookmark_healthrecord = 'bookmark-healthrecord';
const String qr_healthOrgType = '?healthOrganizationType=';
const String qr_limitSearchText = '&limit=10&searchText=';
const String qr_sortByDesc = '&sortBy=desc&skip=0';
const String qr_patient_update_default = 'patient-provider-mapping/';
const String qr_provider_mapping = 'provider-mapping/';
const String qr_health_org_id = 'healthOrganizationId';

const String qr_shareFromUser = 'shareFromUser';
const String qr_shareToProvider = 'shareToProvider';
const String qr_metadata = 'metadata';

const String external_available_device =
    'external-integration-api/available-service?';
const String unpair_dexcomm = 'external-integration-api/unpair-device';
const String qr_user_profile = 'user-profile-setting/';
const String qr_my_profile = 'my-profile';
const String qr_member_id = '?memberId=';
const String qr_user_profile_no_slash = 'user-profile-setting';
const String qr_save_health_rec = 'save-health-record';
const String qr_digit_recog = 'digit-recognization/';
const String ar_doctor_list = 'doctor-list?search=&healthOrganizationId=';
const String qr_isCareGiver = '&isCaregiver='; //parameter names changed

const String qr_str_id = 'id';
const String qr_healthRecordMetaData = 'healthRecordMetaData';
const String qr_healthRecordType = 'healthRecordType';
const String qr_update_appointment_records = '/update-appointment-records';

const String appointmentSlash = 'appointment/';
const String patientIdEqualTo = 'chat-screen-details?patientId=';
const String userIdChat = '&userId=';
const String peerIdChat = '&peerId=';
const String doctorIdEqualTo = '&doctorId=';
const String device_health = 'device-health-record/';

const String qr_isSkipUnknown = 'isSkipUnknown=';
const String qr_Google_TTS_Proxy_URL = 'google-tts/proxy';
const String qr_Google_TTS_Regiment_URL = 'google-tts/google-translate/proxy';

const String qr_plan_list = 'plan-package-master/wrapperApi';
const String qr_power_bi = 'power-bi';
const String qr_getUserPack = 'Action=GetUserPackages';
const String qr_getPack = 'Action=GetPackages';
const String qr_getPack_details = 'Action=GetPackages&packageid=';
const String qr_getSearchList = 'Action=GetProviderList';
const String qr_getUserSearchList = 'Action=GetUserProviderList';
const String qr_qEqaul = '&q=';
const String qr_providerEqaul = '&providerid=';
const String qr_patientEqaul = '&patientId=';
const String qr_timeEqaul = '&time=';
const String qr_getUserPackDetail = 'Action=GetUserPlanDetails&packageid=';
const String qr_subscribePlan = 'Action=Subscribe&packageid=';
const String qr_UnsubscribePlan = 'Action=UnSubscribe&packageid=';
const String qr_get = 'get';
const String regiment = 'plan-package-master/wrapperApi';
const String regimentCalendar =
    'qurplan-node-mysql/regimen-calendar-filter/363ba935-3e4d-4024-b81c-bfd04fdc1ef4?startDate=2023-03-01%2000%3A00%3A00&endDate=2023-05-31%2000%3A00%3A00';
const String qr_save_regi_media = 'media-details/store-media';
const String regimentImagePath = 'https://qurplan.com/assets/images/';
const String getEventId = 'activity-master/save-personal-plan-symptom';

const String getCreditBalnce = 'credit-balance/';
const String getClaimWithQues = 'claim?userId=';

const String qr_health_conditions = 'Action=GetMenu';

const String getMenuCarePlans = 'Action=GetMenuTaggedPackages&tags=';

const String excludeDiet = '&extags=diet,MEMB';

const String onlyProvider = '&onlymyprovider=1';

const String onlyFreePlans = '&onlyfree=1';

const String getMenuDietPlans = 'Action=GetMenuTaggedPackages&tags=';

const String diet = ',diet';

const String veg = ',veg';

const String prid = '&prid=';

const String exact = '&exact=1';

const String qr_user_plan = 'user-plans/';

const String qr_list = 'list/';
const String qr_doctorlist = 'doctorsList?';
const String qr_halthOrganization = 'healthOrganizationTypeId=';
const String qr_healthOrganizationList = 'healthOrganizationsList?';
const String qr_qur_plan_dashboard = 'qur-plan-dashboard?';
const String qr_userid_dashboard = '&userId=';
const String qr_date = '&date=';

const String app_screen_config = 'user/app-screen-config';

const String qr_module_equal = '&module=';
const String qr_healthOrg = 'healthOrganization';
const String qr_all = 'all';
const String qr_helperVideos = 'helperVideos';
const String qr_careGiverList = 'careGiverList';

const String qr_createSubscribe = 'payment/plan-subscription-create-payment';
const String qr_add_cart = 'cart/add-product';

const String qr_code_tags = 'TAGS';

const String retry_payment = 'appointment/check-retry-appointment?id=';
const String appointmentUsingId = 'appointment/get/';

// True desk

const String qr_get_tickets = 'trudesk/ticket/list';
const String qr_get_ticket_details = 'trudesk/ticket/details';
const String qr_get_ticket_types = 'trudesk/ticket/types';
const String qr_create_ticket = 'trudesk/create/ticket/by-patient';
const String qr_comment_ticket = 'trudesk/ticket/comment';
const String qr_upload_attachment = 'trudesk/tickets/uploadattachment';

///for claims
const String qr_submittedby = 'submittedBy';
const String qr_submittedfor = 'submittedFor';
const String qr_ClaimAmountTotal = 'claimAmountTotal';
const String qr_remark = 'remark';
const String qr_documentMetadata = 'documentMetadata';
const String qr_membership_tag = 'membership';

const String qr_billName = 'bill_name';
const String qr_claimType = 'claim_type';
const String qr_claimAmount = 'claim_amount';
const String qr_billDate = 'bill_date';
const String qr_healthRecordId = 'health_record_id';
const String qr_memoText = 'memo_text';
const String qr_claim = 'claim';
const String qr_claim_with_slash = 'claim/';
const String qr_healthRecordMetaIds = 'healthRecordMetaIds';

//chat

const String qr_chat_socket_history = 'chat/get-message-history';
const String qr_init_rrt_notification =
    "appointment-pending-schedule/confirm-preferred-date";
//sheela bagde

const String qr_sheela_badge_icon_count =
    'notification-log/sheela-pending-queue/';

// family list mapping

const String qr_chat_family_mapping =
    'user-relationship/get-shared-caregivers-list';

const String qr_unread_family_chat =
    'chat/get-unread-notification-count-by-user';

const String qr_unread_chat_count_msg_id =
    'chat/update-individual-chat-message-read-flag';

const String qr_chat_socket_init_chat_doc_pat =
    'chat/initiate-doctor-patient-chat';

const String qr_chat_socket_init_chat_pat_doc =
    'chat/initiate-patient-doctor-chat';

const String qr_chat_socket_init_chat_pat_family =
    'chat/initiate-patient-primary-caregiver-chat';

const String qr_chat_socket_get_user_id_doc = 'doctor/';

const String qr_chat_socket_get_user_id_doc_include = '?include=personal';

const String qr_hub = 'qur-hub/user-hub';

// qurHome Symptom

const String qr_list_symptom = 'qurplan-node-mysql/get-userFormData/';
const String qr_symp_date = '?date=';
const String qr_is_symptom =
    '&isSymptom=true&asNeeded=false&providerId=null&page=1&size=50&searchText=&sorts=activity|ASC';
const String qr_delink_check = "user-relationship/check-caregiver-association";

//sheela queue

const String qr_sheela_post_queue = 'notification-log/sheela-queue-insert';
const String qurPlanNode = 'qurplan-node-mysql';
const String updateSnoozeEvent = '/update-snoozed-event';

// activity status our api

const String user_activity_status = 'activity-master/user-activity-status?eid=';

const String user_activity_status_date = '&date=';

const String get_city_list = 'city/search/';

const String get_sos_setting_status =
    'patient-provider-mapping/sos-setting-status/';

//app error log
const String strAppVersion = 'appVersion';
const String strOSVersion = 'osVersion';
const String strDeviceName = 'deviceName';
const String strException = 'exception';
const String post_event_logapp_logs = 'event-log/app-logs';
const String appName = 'appName';

const String platformIOS = '&platform=ios';
const String qr_Text_Translate = 'sheela/text-translate';
const String qr_textToTranslate = 'textToTranslate';
const String qr_targetLanguageCode = 'TargetLanguageCode';
const String qr_sourceLanguageCode = 'sourceLanguageCode';

//captureUserLastAccessTime
const String lastAccessTime = 'lastAccessTime';
const String save_last_access_time = 'user/device-audit-logs';


// Constants related to Voice Clone Patient Assignment
const String qr_voiceCloneId = 'voiceCloneId';
// Constant representing the key for Voice Clone ID

const String qr_statusCode = 'statusCode';
// Constant representing the key for status code

const String qr_vc_accept = 'VCAPPROVED';
// Constant representing the value for Voice Clone approval

const String qr_vc_decline = 'VCDECLINED';
// Constant representing the value for Voice Clone decline

const String save_voice_clone_patient_assignment_status = 'voice-clone/accept-reject-requests';
// Constant representing the endpoint to save Voice Clone Patient Assignment status.


const String qr_TTS_Proxy_URL = 'tts/proxy';
const String qr_Get_VoiceId = 'voice-clone/user-vc-details?userId=';
const String qr_voiceId = 'voiceId';

// Define a constant string for the key 'doctor/service-request/list'
const String doctor_service_request_list = 'doctor/service-request/list';

// Define a constant String named 'lab_service_request_list' with the value 'health-organization/service-request/list'
const String lab_service_request_list = 'health-organization/service-request/list';

