import '../../constants/fhb_parameters.dart' as parameters;

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
    countryCode = obj[parameters.strCountryCode];
    name = obj[parameters.strName];
    bpSPUnit = obj[parameters.strbpSPUnit];
    bpDPUnit = obj[parameters.strbpDPUnit];
    bpPulseUnit = obj[parameters.strbpPulseUnit];
    glucometerUnit = obj[parameters.strglucometerUnit];
    poOxySatUnit = obj[parameters.strpoOxySatUnit];
    poPulseUnit = obj[parameters.strpoPulseUnit];
    tempUnit = obj[parameters.strtempUnit];

    weightUnit = obj[parameters.strweightUnit];
  }
  CountryMetrics.map(obj) {
    countryCode = obj[parameters.strCountryCode];
    name = obj[parameters.strName];
    bpSPUnit = obj[parameters.strbpSPUnit];
    bpDPUnit = obj[parameters.strbpDPUnit];
    bpPulseUnit = obj[parameters.strbpPulseUnit];
    glucometerUnit = obj[parameters.strglucometerUnit];
    poOxySatUnit = obj[parameters.strpoOxySatUnit];
    poPulseUnit = obj[parameters.strpoPulseUnit];
    tempUnit = obj[parameters.strtempUnit];

    weightUnit = obj[parameters.strweightUnit];
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
    final obj = Map<String, dynamic>();

    obj[parameters.strCountryCode] = countryCode;
    obj[parameters.strName] = name;
    obj[parameters.strbpSPUnit] = bpSPUnit;
    obj[parameters.strbpDPUnit] = bpDPUnit;
    obj[parameters.strbpPulseUnit] = bpPulseUnit;
    obj[parameters.strglucometerUnit] = glucometerUnit;
    obj[parameters.strpoOxySatUnit] = poOxySatUnit;
    obj[parameters.strpoPulseUnit] = poPulseUnit;
    obj[parameters.strtempUnit] = tempUnit;

    obj[parameters.strweightUnit] = weightUnit;
    return obj;
  }

  void setUserId(int countryCode) {
    this.countryCode = countryCode;
  }
}
