import 'package:flutter/material.dart';

class UserInsertResult {
  final bool success;
  final AppUser? user;

  UserInsertResult({required this.success, this.user});
}

class AppUser {
  String? appUserId;
  String? firstName;
  String? email;
  String? lastName;
  String? password;
  String? confirmPassword;

  AppUser({
    this.appUserId,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.confirmPassword,
  });

  // For Firebase or JSON
  AppUser.fromJson(Map<String, dynamic> json, String id) {
    appUserId = id;
    firstName = json['firstName'] ?? '';
    email = json['email'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'appUserId': appUserId,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'lastName': lastName,
    };
  }

  // For SQLite
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      appUserId: map['appUserId']?.toString(),
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      password: map['password'],
    );
  }
}
