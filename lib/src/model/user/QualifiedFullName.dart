import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class QualifiedFullName {
	String lastName;
	String firstName;
	String middleName;

	QualifiedFullName({this.lastName, this.firstName, this.middleName});

	QualifiedFullName.fromJson(Map<String, dynamic> json) {
		lastName = json[parameters.strlastName];
		firstName = json[parameters.strfirstName];
		middleName = json[parameters.strmiddleName];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data[parameters.strlastName] = this.lastName;
		data[parameters.strfirstName] = this.firstName;
		data[parameters.strmiddleName] = this.middleName;
		return data;
	}
}