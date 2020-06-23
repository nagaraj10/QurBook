class CountryMetrics {
  int countryCode;
  String name;
  String bpSPUnit;
  String bpDPUnit;
  String bpPulseUnit;
  String glucometerUnit;
  String poOxySatUnit;
  String poPulseUnit;
  String tempUnit;
  String weightUnit;

  CountryMetrics(
      this.countryCode,
      this.name,
      this.bpSPUnit,
      this.bpDPUnit,
      this.bpPulseUnit,
      this.glucometerUnit,
      this.poOxySatUnit,
      this.poPulseUnit,
      this.tempUnit,
      this.weightUnit);

 CountryMetrics.fromJson(Map<String, dynamic> obj) {
    countryCode = obj["countryCode"];
    name = obj["name"];
    bpSPUnit = obj["bpSPUnit"];
    bpDPUnit = obj["bpDPUnit"];
    bpPulseUnit = obj["bpPulseUnit"];
    glucometerUnit = obj["glucometerUnit"];
    poOxySatUnit = obj["poOxySatUnit"];
    poPulseUnit = obj["poPulseUnit"];
    tempUnit = obj["tempUnit"];

    weightUnit = obj["weightUnit"];
  }
  CountryMetrics.map(dynamic obj) {
    this.countryCode = obj["countryCode"];
    this.name = obj["name"];
    this.bpSPUnit = obj["bpSPUnit"];
    this.bpDPUnit = obj["bpDPUnit"];
    this.bpPulseUnit = obj["bpPulseUnit"];
    this.glucometerUnit = obj["glucometerUnit"];
    this.poOxySatUnit = obj["poOxySatUnit"];
    this.poPulseUnit = obj["poPulseUnit"];
    this.tempUnit = obj["tempUnit"];

    this.weightUnit = obj["weightUnit"];
  }

 /* String get countryName => name;

  String get bpSPUNIT => bpSPUnit;
  String get bpDPUNIT => bpDPUnit;
  String get bpPulseUNIT => bpPulseUnit;
  String get glucometerUNIT => glucometerUnit;
  String get poOxySatUNIT => poOxySatUnit;
  String get poPulseUNIT => poPulseUnit;
  String get tempUNIT => tempUnit;

  String get weightUNIT => weightUnit;*/

  Map<String, dynamic> toMap() {
    var obj = new Map<String, dynamic>();

    obj["countryCode"] = countryCode;
    obj["name"] = name;
    obj["bpSPUnit"] = bpSPUnit;
    obj["bpDPUnit"] = bpDPUnit;
    obj["bpPulseUnit"] = bpPulseUnit;
    obj["glucometerUnit"] = glucometerUnit;
    obj["poOxySatUnit"] = poOxySatUnit;
    obj["poPulseUnit"] = poPulseUnit;
    obj["tempUnit"] = tempUnit;

    obj["weightUnit"] = weightUnit;
    return obj;
  }

 

  void setUserId(int countryCode) {
    this.countryCode = countryCode;
  }
}
