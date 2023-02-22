import 'package:cloud_firestore/cloud_firestore.dart';

class UdemyCoursesModel
{
  String courseCategory;
  String courseName;
  String courseDriveLink;
  String courseDescription;
  String image_01;
  String image_02;
  String image_03;
  int loves;
  String date;
  String timestamp;

  UdemyCoursesModel({this.courseCategory, this.courseName, this.courseDriveLink, this.courseDescription, this.image_01, this.image_02, this.image_03, this.loves, this.date, this.timestamp});

  factory UdemyCoursesModel.fromFirestore(DocumentSnapshot snapshot)
  {
    Map<String, dynamic> d = snapshot.data();
    return UdemyCoursesModel(
      courseCategory: d['COURSE CATEGORY'],
      courseName: d['COURSE NAME'],
      courseDriveLink: d['COURSE LINK'],
      courseDescription: d['DESCRIPTION'],
      image_01: d['IMAGE 01'],
      image_02: d['IMAGE 02'],
      image_03: d['IMAGE 03'],
      loves: d['LOVES'],
      date: d['DATE'],
      timestamp: d['TIMESTAMP'],
    );
  }
}