import 'package:flutter/material.dart';

class UserProfile {
  String name;
  String email;
  String password;
  String? imagePath;
  String country;
  String countryCode;
  String address;
  String age;
  String job;
  String maritalStatus;
  String pob;
  String dob;
  String religion;
  String citizenship;
  String gender;
  String bloodType;

  int dailyGoal;
  bool isTargetPermanent;
  DateTime? targetSetDate;

  int totalCompleted;
  int totalUncompleted;
  int totalIgnored;
  int currentStreak;

  UserProfile({
    required this.name,
    required this.email,
    this.password = "123456",
    this.imagePath,
    this.country = "Indonesia",
    this.countryCode = "+62",
    this.address = "-",
    this.age = "-",
    this.job = "-",
    this.maritalStatus = "Belum Menikah",
    this.pob = "-",
    this.dob = "-",
    this.religion = "-",
    this.citizenship = "-",
    this.gender = "Laki-laki",
    this.bloodType = "-",
    this.dailyGoal = 5,
    this.isTargetPermanent = false,
    this.targetSetDate,
    this.totalCompleted = 0,
    this.totalUncompleted = 0,
    this.totalIgnored = 0,
    this.currentStreak = 0,
  });
}