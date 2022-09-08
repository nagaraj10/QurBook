class UnitConfiguration {
  bool isSuccess;
  List<Result> result;

  UnitConfiguration({this.isSuccess, this.result});

  UnitConfiguration.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result?.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String id;
  String code;
  String name;
  ConfigurationData configurationData;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  Result(
      {this.id,
      this.code,
      this.name,
      this.configurationData,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    configurationData = json['configurationData'] != null
        ? new ConfigurationData.fromJson(json['configurationData'])
        : null;
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    if (this.configurationData != null) {
      data['configurationData'] = this.configurationData?.toJson();
    }
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class ConfigurationData {
  UnitSystemList unitSystemList;
  DbDefaultUnitSystem dbDefaultUnitSystem;
  DbDefaultUnitSystem unitConversion;

  ConfigurationData(
      {this.unitSystemList, this.dbDefaultUnitSystem, this.unitConversion});

  ConfigurationData.fromJson(Map<String, dynamic> json) {
    unitSystemList = json['unit-system-list'] != null
        ? new UnitSystemList.fromJson(json['unit-system-list'])
        : null;
    dbDefaultUnitSystem = json['db-default-unit-system'] != null
        ? new DbDefaultUnitSystem.fromJson(json['db-default-unit-system'])
        : null;
    unitConversion = json['unit-conversion'] != null
        ? new DbDefaultUnitSystem.fromJson(json['unit-conversion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.unitSystemList != null) {
      data['unit-system-list'] = this.unitSystemList?.toJson();
    }
    if (this.dbDefaultUnitSystem != null) {
      data['db-default-unit-system'] = this.dbDefaultUnitSystem?.toJson();
    }
    if (this.unitConversion != null) {
      data['unit-conversion'] = this.unitConversion?.toJson();
    }
    return data;
  }
}

class UnitSystemList {
  India india;
  India us;

  UnitSystemList({this.india, this.us});

  UnitSystemList.fromJson(Map<String, dynamic> json) {
    india = json['india'] != null ? new India.fromJson(json['india']) : null;
    us = json['us'] != null ? new India.fromJson(json['us']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.india != null) {
      data['india'] = this.india?.toJson();
    }
    if (this.us != null) {
      data['us'] = this.us?.toJson();
    }
    return data;
  }
}

class India {
  List<Height> height;
  List<Height> weight;
  List<Height> temperature;

  India({this.height, this.weight, this.temperature});

  India.fromJson(Map<String, dynamic> json) {
    if (json['height'] != null) {
      height = <Height>[];
      json['height'].forEach((v) {
        height?.add(new Height.fromJson(v));
      });
    }
    if (json['weight'] != null) {
      weight = <Height>[];
      json['weight'].forEach((v) {
        weight?.add(new Height.fromJson(v));
      });
    }
    if (json['temperature'] != null) {
      temperature = <Height>[];
      json['temperature'].forEach((v) {
        temperature?.add(new Height.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.height != null) {
      data['height'] = this.height?.map((v) => v.toJson()).toList();
    }
    if (this.weight != null) {
      data['weight'] = this.weight?.map((v) => v.toJson()).toList();
    }
    if (this.temperature != null) {
      data['temperature'] = this.temperature?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Height {
  String unitCode;
  String unitName;

  Height({this.unitCode, this.unitName});

  Height.fromJson(Map<String, dynamic> json) {
    unitCode = json['unitCode'];
    unitName = json['unitName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitCode'] = this.unitCode;
    data['unitName'] = this.unitName;
    return data;
  }
}

class DbDefaultUnitSystem {
  HeightDefault height;
  HeightDefault weight;
  HeightDefault temperature;

  DbDefaultUnitSystem({this.height, this.weight, this.temperature});

  DbDefaultUnitSystem.fromJson(Map<String, dynamic> json) {
    height = json['height'] != null
        ? new HeightDefault.fromJson(json['height'])
        : null;
    weight = json['weight'] != null
        ? new HeightDefault.fromJson(json['weight'])
        : null;
    temperature = json['temperature'] != null
        ? new HeightDefault.fromJson(json['temperature'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.height != null) {
      data['height'] = this.height?.toJson();
    }
    if (this.weight != null) {
      data['weight'] = this.weight?.toJson();
    }
    if (this.temperature != null) {
      data['temperature'] = this.temperature?.toJson();
    }
    return data;
  }
}

class HeightDefault {
  FInCm fInCm;
  CmFIn cmFIn;

  HeightDefault({this.fInCm, this.cmFIn});

  HeightDefault.fromJson(Map<String, dynamic> json) {
    fInCm =
        json['f-in-cm'] != null ? new FInCm.fromJson(json['f-in-cm']) : null;
    cmFIn =
        json['cm-f-in'] != null ? new CmFIn.fromJson(json['cm-f-in']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fInCm != null) {
      data['f-in-cm'] = this.fInCm?.toJson();
    }
    if (this.cmFIn != null) {
      data['cm-f-in'] = this.cmFIn?.toJson();
    }
    return data;
  }
}

class FInCm {
  String conversionFormula;

  FInCm({this.conversionFormula});

  FInCm.fromJson(Map<String, dynamic> json) {
    conversionFormula = json['conversionFormula'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversionFormula'] = this.conversionFormula;
    return data;
  }
}

class CmFIn {
  String conversionFormulaToFeet;
  String conversionFormulaToInches;

  CmFIn({this.conversionFormulaToFeet, this.conversionFormulaToInches});

  CmFIn.fromJson(Map<String, dynamic> json) {
    conversionFormulaToFeet = json['conversionFormulaToFeet'];
    conversionFormulaToInches = json['conversionFormulaToInches'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversionFormulaToFeet'] = this.conversionFormulaToFeet;
    data['conversionFormulaToInches'] = this.conversionFormulaToInches;
    return data;
  }
}

class Weight {
  FInCm kgLb;
  FInCm lbKg;

  Weight({this.kgLb, this.lbKg});

  Weight.fromJson(Map<String, dynamic> json) {
    kgLb = json['kg-lb'] != null ? new FInCm.fromJson(json['kg-lb']) : null;
    lbKg = json['lb-kg'] != null ? new FInCm.fromJson(json['lb-kg']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.kgLb != null) {
      data['kg-lb'] = this.kgLb?.toJson();
    }
    if (this.lbKg != null) {
      data['lb-kg'] = this.lbKg?.toJson();
    }
    return data;
  }
}

class Temperature {
  FInCm cF;
  FInCm fC;

  Temperature({this.cF, this.fC});

  Temperature.fromJson(Map<String, dynamic> json) {
    cF = json['c-f'] != null ? new FInCm.fromJson(json['c-f']) : null;
    fC = json['f-c'] != null ? new FInCm.fromJson(json['f-c']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cF != null) {
      data['c-f'] = this.cF?.toJson();
    }
    if (this.fC != null) {
      data['f-c'] = this.fC?.toJson();
    }
    return data;
  }
}
