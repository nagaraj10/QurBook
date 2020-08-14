class DeviceValues {
  bool isSuccess;
  List<DeviceResult> result;

  DeviceValues({this.isSuccess, this.result});

  DeviceValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<DeviceResult>();
      json['result'].forEach((v) {
        result.add(new DeviceResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeviceResult {
  BloodGlucose bloodGlucose;
  BloodPressure bloodPressure;
  BodyTemp bodyTemperature;
  BodyWeight bodyWeight;
  HeartRate heartRate;
  OxygenSat oxygenSaturation;
  DeviceResult(
      {this.bloodGlucose,
      this.bloodPressure,
      this.bodyTemperature,
      this.bodyWeight,
      this.heartRate,
      this.oxygenSaturation});

  DeviceResult.fromJson(Map<String, dynamic> json) {
    bloodGlucose = json['bloodGlucose'] != null
        ? new BloodGlucose.fromJson(json['bloodGlucose'])
        : null;
    bloodPressure = json['bloodPressure'] != null
        ? new BloodPressure.fromJson(json['bloodPressure'])
        : null;
    bodyTemperature = json['bodyTemperature'] != null
        ? new BodyTemp.fromJson(json['bodyTemperature'])
        : null;
    bodyWeight = json['bodyWeight'] != null
        ? new BodyWeight.fromJson(json['bodyWeight'])
        : null;
    heartRate = json['heartRate'] != null
        ? new HeartRate.fromJson(json['heartRate'])
        : null;
    oxygenSaturation = json['oxygenSaturation'] != null
        ? new OxygenSat.fromJson(json['oxygenSaturation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bloodGlucose != null) {
      data['bloodGlucose'] = this.bloodGlucose.toJson();
    }
    if (this.bloodPressure != null) {
      data['bloodPressure'] = this.bloodPressure.toJson();
    }
    if (this.bodyTemperature != null) {
      data['bodyTemperature'] = this.bodyTemperature.toJson();
    }
    if (this.bodyWeight != null) {
      data['bodyWeight'] = this.bodyWeight.toJson();
    }
    if (this.heartRate != null) {
      data['heartRate'] = this.heartRate.toJson();
    }
    if (this.oxygenSaturation != null) {
      data['oxygenSaturation'] = this.oxygenSaturation.toJson();
    }
    return data;
  }
}

class BloodGlucose {
  bool isSuccess;
  List<Entities> entities;

  BloodGlucose({this.isSuccess, this.entities});

  BloodGlucose.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['entities'] != null) {
      entities = new List<Entities>();
      json['entities'].forEach((v) {
        entities.add(new Entities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.entities != null) {
      data['entities'] = this.entities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Entities {
  String lastsyncdatetime;
  String bloodGlucoseLevel;
  String bgunit;
  String source;

  Entities(
      {this.lastsyncdatetime,
      this.bloodGlucoseLevel,
      this.bgunit,
      this.source});

  Entities.fromJson(Map<String, dynamic> json) {
    lastsyncdatetime = json['lastsyncdatetime'];
    bloodGlucoseLevel = json['bloodGlucoseLevel'];
    bgunit = json['bgunit'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastsyncdatetime'] = this.lastsyncdatetime;
    data['bloodGlucoseLevel'] = this.bloodGlucoseLevel;
    data['bgunit'] = this.bgunit;
    data['source'] = this.source;
    return data;
  }
}

class BloodPressure {
  bool isSuccess;
  List<BPEntities> entities;

  BloodPressure({this.isSuccess, this.entities});

  BloodPressure.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['entities'] != null) {
      entities = new List<BPEntities>();
      json['entities'].forEach((v) {
        entities.add(new BPEntities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.entities != null) {
      data['entities'] = this.entities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BodyTemp {
  bool isSuccess;
  List<BTEntities> entities;

  BodyTemp({this.isSuccess, this.entities});

  BodyTemp.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['entities'] != null) {
      entities = new List<BTEntities>();
      json['entities'].forEach((v) {
        entities.add(new BTEntities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.entities != null) {
      data['entities'] = this.entities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BodyWeight {
  bool isSuccess;
  List<BWEntities> entities;

  BodyWeight({this.isSuccess, this.entities});

  BodyWeight.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['entities'] != null) {
      entities = new List<BWEntities>();
      json['entities'].forEach((v) {
        entities.add(new BWEntities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.entities != null) {
      data['entities'] = this.entities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HeartRate {
  bool isSuccess;
  List<HREntities> entities;

  HeartRate({this.isSuccess, this.entities});

  HeartRate.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['entities'] != null) {
      entities = new List<HREntities>();
      json['entities'].forEach((v) {
        entities.add(new HREntities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.entities != null) {
      data['entities'] = this.entities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OxygenSat {
  bool isSuccess;
  List<OSEntities> entities;

  OxygenSat({this.isSuccess, this.entities});

  OxygenSat.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['entities'] != null) {
      entities = new List<OSEntities>();
      json['entities'].forEach((v) {
        entities.add(new OSEntities.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.entities != null) {
      data['entities'] = this.entities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BPEntities {
  String lastsyncdatetime;
  String systolic;
  String diostolic;
  String source;

  BPEntities(
      {this.lastsyncdatetime, this.systolic, this.diostolic, this.source});

  BPEntities.fromJson(Map<String, dynamic> json) {
    lastsyncdatetime = json['lastsyncdatetime'];
    systolic = json['systolic'];
    diostolic = json['diostolic'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastsyncdatetime'] = this.lastsyncdatetime;
    data['systolic'] = this.systolic;
    data['diostolic'] = this.diostolic;
    data['source'] = this.source;
    return data;
  }
}

class BTEntities {
  String lastsyncdatetime;
  String temperature;
  String temperatureunit;
  String source;

  BTEntities(
      {this.lastsyncdatetime,
      this.temperature,
      this.temperatureunit,
      this.source});

  BTEntities.fromJson(Map<String, dynamic> json) {
    lastsyncdatetime = json['lastsyncdatetime'];
    temperature = json['temperature'];
    temperatureunit = json['temperatureunit'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastsyncdatetime'] = this.lastsyncdatetime;
    data['temperature'] = this.temperature;
    data['temperatureunit'] = this.temperatureunit;
    data['source'] = this.source;
    return data;
  }
}

class BWEntities {
  String lastsyncdatetime;
  String weight;
  String weightunit;
  String source;

  BWEntities(
      {this.lastsyncdatetime, this.weight, this.weightunit, this.source});

  BWEntities.fromJson(Map<String, dynamic> json) {
    lastsyncdatetime = json['lastsyncdatetime'];
    weight = json['weight'];
    weightunit = json['weightunit'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastsyncdatetime'] = this.lastsyncdatetime;
    data['weight'] = this.weight;
    data['weightunit'] = this.weightunit;
    data['source'] = this.source;
    return data;
  }
}

class HREntities {
  String lastsyncdatetime;
  String bpm;
  String source;

  HREntities({this.lastsyncdatetime, this.bpm, this.source});

  HREntities.fromJson(Map<String, dynamic> json) {
    lastsyncdatetime = json['lastsyncdatetime'];
    bpm = json['bpm'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastsyncdatetime'] = this.lastsyncdatetime;
    data['bpm'] = this.bpm;
    data['source'] = this.source;
    return data;
  }
}

class OSEntities {
  String lastsyncdatetime;
  String oxygenSaturation;
  String source;

  OSEntities({this.lastsyncdatetime, this.oxygenSaturation, this.source});

  OSEntities.fromJson(Map<String, dynamic> json) {
    lastsyncdatetime = json['lastsyncdatetime'];
    oxygenSaturation = json['oxygenSaturation'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastsyncdatetime'] = this.lastsyncdatetime;
    data['oxygenSaturation'] = this.oxygenSaturation;
    data['source'] = this.source;
    return data;
  }
}
