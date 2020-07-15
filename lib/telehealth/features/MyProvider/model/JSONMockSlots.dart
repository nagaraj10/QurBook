class JSONMockSlots {
  var mockList = {
    "status": 200,
    "success": true,
    "message": "Found sessions, fetching back the availability",
    "response": {
      "count": 6,
      "data": {
        "doctorId": "c99b732e-d630-4301-b3fa-e7c800b891b4",
        "date": "2020-07-06",
        "day": "Monday",
        "sessionCounts": 2,
        "sessions": [
          {
            "doctorSessionId": "4bbe1fad-baff-41ed-b853-34dcc7c991f1",
            "sessionStartTime": "10:00:00",
            "sessionEndTime": "12:00:00",
            "slotCounts": 4,
            "slots": [
              {
                "startTime": "10:00:00",
                "endTime": "10:30:00",
                "isAvailable": false,
                "slotNumber": 1
              },
              {
                "startTime": "10:30:00",
                "endTime": "11:00:00",
                "isAvailable": true,
                "slotNumber": 2
              },
              {
                "startTime": "11:00:00",
                "endTime": "11:30:00",
                "isAvailable": true,
                "slotNumber": 3
              },
              {
                "startTime": "11:30:00",
                "endTime": "12:00:00",
                "isAvailable": true,
                "slotNumber": 4
              },{
                "startTime": "10:30:00",
                "endTime": "11:00:00",
                "isAvailable": true,
                "slotNumber": 2
              },
              {
                "startTime": "11:00:00",
                "endTime": "11:30:00",
                "isAvailable": true,
                "slotNumber": 3
              },
              {
                "startTime": "11:30:00",
                "endTime": "12:00:00",
                "isAvailable": true,
                "slotNumber": 4
              }
            ]
          },
          {
            "doctorSessionId": "ac9d114d-8e01-4c09-8d75-88b990ded4c3",
            "sessionStartTime": "17:00:00",
            "sessionEndTime": "18:00:00",
            "slotCounts": 2,
            "slots": [
              {
                "startTime": "17:00:00",
                "endTime": "17:30:00",
                "isAvailable": true,
                "slotNumber": 1
              },
              {
                "startTime": "17:30:00",
                "endTime": "18:00:00",
                "isAvailable": false,
                "slotNumber": 2
              },{
                "startTime": "17:00:00",
                "endTime": "17:30:00",
                "isAvailable": true,
                "slotNumber": 1
              },
              {
                "startTime": "17:30:00",
                "endTime": "18:00:00",
                "isAvailable": false,
                "slotNumber": 2
              },{
                "startTime": "17:00:00",
                "endTime": "17:30:00",
                "isAvailable": true,
                "slotNumber": 1
              },
              {
                "startTime": "17:30:00",
                "endTime": "18:00:00",
                "isAvailable": false,
                "slotNumber": 2
              },{
                "startTime": "17:00:00",
                "endTime": "17:30:00",
                "isAvailable": true,
                "slotNumber": 1
              },
              {
                "startTime": "17:30:00",
                "endTime": "18:00:00",
                "isAvailable": false,
                "slotNumber": 2
              }
            ]
          },
          {
            "doctorSessionId": "4bbe1fad-baff-41ed-b853-34dcc7c991f1",
            "sessionStartTime": "14:00:00",
            "sessionEndTime": "16:00:00",
            "slotCounts": 6,
            "slots": [
              {
                "startTime": "10:00:00",
                "endTime": "10:30:00",
                "isAvailable": false,
                "slotNumber": 1
              },
              {
                "startTime": "10:30:00",
                "endTime": "11:00:00",
                "isAvailable": true,
                "slotNumber": 2
              },
              {
                "startTime": "11:00:00",
                "endTime": "11:30:00",
                "isAvailable": true,
                "slotNumber": 3
              },
              {
                "startTime": "11:30:00",
                "endTime": "12:00:00",
                "isAvailable": true,
                "slotNumber": 4
              },{
                "startTime": "10:30:00",
                "endTime": "11:00:00",
                "isAvailable": true,
                "slotNumber": 2
              },
              {
                "startTime": "11:00:00",
                "endTime": "11:30:00",
                "isAvailable": true,
                "slotNumber": 3
              },
              {
                "startTime": "11:30:00",
                "endTime": "12:00:00",
                "isAvailable": true,
                "slotNumber": 4
              }
            ]
          }
        ]
      }
    }
  };
}
