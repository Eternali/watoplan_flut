import 'package:watoplan/utils/data_utils.dart';

class Person {

  final int _id;
  int get id => id;
  final String firstName;
  final String lastName;
  String get fullName => firstName + ' ' + lastName;
  

  Person({ int id, this.firstName, this.lastName }) : _id = id ?? generateId();

  factory Person.fromJson(Map<String, dynamic> jsonMap) {
    return new Person(
      id: jsonMap['_id'],
      firstName: jsonMap['firstName'],
      lastName: jsonMap['lastName'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': _id,
    'firstName': firstName,
    'lastName': lastName,
  };

}
