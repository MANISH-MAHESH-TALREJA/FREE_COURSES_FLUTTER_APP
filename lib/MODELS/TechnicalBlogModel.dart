import 'package:cloud_firestore/cloud_firestore.dart';

class TechnicalBlogModel
{
  String title;
  String description;
  String thumbnail;
  int loves;
  String blogLink;
  String date;
  String timestamp;

  TechnicalBlogModel({this.title, this.description, this.thumbnail, this.loves, this.blogLink, this.date, this.timestamp});

  factory TechnicalBlogModel.fromFirestore(DocumentSnapshot snapshot)
  {
    Map<String, dynamic> d = snapshot.data();
    return TechnicalBlogModel(
      title: d['BLOG TITLE'],
      description: d['BLOG DESCRIPTION'],
      thumbnail: d['BLOG IMAGE'],
      loves: d['LOVES'],
      blogLink: d['BLOG LINK'],
      date: d['DATE'],
      timestamp: d['TIMESTAMP'],
    );
  }
}
