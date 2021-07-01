import '../../../constants/fhb_parameters.dart' as parameters;

class DeviceMeasurementsData {
  String parameter;
  String unit;
  String values;

  DeviceMeasurementsData({this.parameter, this.unit, this.values});

  DeviceMeasurementsData.fromJson(Map<String, dynamic> json) {
  


     try{
          parameter = json[parameters.strParameters];

 if (json[parameters.strValues] is int) {
      values =json[parameters.strValues].toString();
    } else {
      values = json[parameters.strValues];
    }
    unit = json[parameters.strunit];
    }catch(e){
      
    }
  }
}
