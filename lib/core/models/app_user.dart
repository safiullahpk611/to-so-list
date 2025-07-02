import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppUser extends ChangeNotifier {
  String? appUserId;
  String? firstName;

  String? userEmail;
  String? lastName;
  String? phoneNumber;
  String? password;
  String? confirmPassword;

  AppUser({
    this.appUserId,
    this.userEmail,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.password,
    this.confirmPassword,
  });

  AppUser.fromJson(json, id) {
    this.appUserId = id;

    this.firstName = json['firstName'] ?? '';
    this.userEmail = json['userEmail'];
    this.lastName = json['lastName'];
    this.phoneNumber = json['phoneNumber'] ?? '';
  }
  toJson() {
    return {
      'firstName': this.firstName,

      'userEmail': this.userEmail,
      'phoneNumber': this.phoneNumber,
      // 'yesterdayTime': this.yesterdayTime,

      'lastName': this.lastName,
      // 'notificationTime': this.notificationTime,
    };
  }
}
