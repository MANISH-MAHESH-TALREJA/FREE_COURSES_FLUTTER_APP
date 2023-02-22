import 'package:cloud_firestore/cloud_firestore.dart';

class UdemyCoursesModel
{
  String? courseCategory;
  String? courseName;
  String? courseDriveLink;
  String? courseDescription;
  String? image_01;
  String? image_02;
  String? image_03;
  int? loves;
  String? date;
  String? timestamp;

  UdemyCoursesModel({this.courseCategory, this.courseName, this.courseDriveLink, this.courseDescription, this.image_01, this.image_02, this.image_03, this.loves, this.date, this.timestamp});

  factory UdemyCoursesModel.fromFirestore(DocumentSnapshot snapshot)
  {
    return UdemyCoursesModel(
      courseCategory: snapshot.get('COURSE CATEGORY'),
      courseName: snapshot.get('COURSE NAME'),
      courseDriveLink: snapshot.get('COURSE LINK'),
      courseDescription: snapshot.get('DESCRIPTION'),
      image_01: snapshot.get('IMAGE 01'),
      image_02: snapshot.get('IMAGE 02'),
      image_03: snapshot.get('IMAGE 03'),
      loves: snapshot.get('LOVES'),
      date: snapshot.get('DATE'),
      timestamp: snapshot.get('TIMESTAMP'),
    );
  }
}