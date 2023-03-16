class Country {
  String name;
  String phoneCode;
  CountryCode countryCode;

  Country({
    this.phoneCode,
    this.name,
    this.countryCode,
  });

  Country.fromCode(String code) {
    phoneCode = code == "IN" ? "+91" : "+1";
    name = code == "IN" ? "India" : "US";
    countryCode = code == "IN" ? CountryCode.IN : CountryCode.US;
  }
}

enum CountryCode {
  IN,
  US,
}
