import 'package:contact_picker/contact_picker.dart';

import 'package:watoplan/utils/data_utils.dart';

class Person extends Contact {

  final int _id;
  int get id => id;

  Person({ int id, String fullName, PhoneNumber phoneNumber })
    : _id = id ?? generateId(), super(fullName: fullName, phoneNumber: phoneNumber);

  factory Person.fromJson(Map<String, dynamic> jsonMap) {
    return new Person(
      id: jsonMap['_id'],
      fullName: jsonMap['fullName'],
      phoneNumber: new PhoneNumber.fromMap(jsonMap['phoneNumber']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'fullName': fullName,
    'phoneNumber': {
      'label': phoneNumber.label,
      'number': phoneNumber.number,
    },
  };

}
