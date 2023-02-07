import '../model/CountryMetrics.dart';
import '../services/database_helper.dart';

class CountryBlock {
  var db = DatabaseHelper();
  CountryBlock();
  delete(CountryMetrics countryMetrics) {
    final db = DatabaseHelper();
    db.deleteCountryMetrics(countryMetrics);
  }

  Future<List<CountryMetrics>> getCountryMetrics() {
    return db.getCountryMetrics();
  }
}
