import 'package:cloud_firestore/cloud_firestore.dart';

class CourseCategoriesModel
{
  String name;
  String categoryImage;
  String timestamp;

  CourseCategoriesModel({this.name, this.categoryImage, this.timestamp});

  factory CourseCategoriesModel.fromFirestore(DocumentSnapshot snapshot)
  {
    Map<String, dynamic> d = snapshot.data();
    return CourseCategoriesModel(
      name: d['CATEGORY NAME'],
      categoryImage: d['CATEGORY THUMBNAIL'],
      timestamp: d['TIMESTAMP'],
    );
  }


  Map<String, dynamic> toJson ()
  {
    return {'CATEGORY NAME' : name, 'CATEGORY THUMBNAIL' : categoryImage, 'TIMESTAMP' : timestamp};
  }
}

