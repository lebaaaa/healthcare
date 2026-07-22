import 'dart:ffi';

class AppUser {
  String name;
  String contact;
  String age;
  String gender;
  String email;
  String userid;
  //TODO add contact, age, gender, etc

  AppUser({
    required this.name,
    required this.contact,
    required this.age,
    required this.gender,
    required this.email,
    required this.userid,
  });
}
