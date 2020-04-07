import 'package:myfhb/database/model/CountryMetrics.dart';
import 'package:myfhb/database/services/database_helper.dart';

class CountryBlock{
var db = new DatabaseHelper();
  CountryBlock();
  delete(CountryMetrics countryMetrics) {
    var db = new DatabaseHelper();
    db.deleteCountryMetrics(countryMetrics);
  }

  Future<List<CountryMetrics>> getCountryMetrics() {
    return db.getCountryMetrics();
  }

}


