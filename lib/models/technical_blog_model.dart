import 'package:cloud_firestore/cloud_firestore.dart';

class TechnicalBlogModel
{
  String? title;
  String? description;
  String? thumbnail;
  int? loves;
  String? blogLink;
  String? date;
  String? timestamp;

  TechnicalBlogModel({this.title, this.description, this.thumbnail, this.loves, this.blogLink, this.date, this.timestamp});

  factory TechnicalBlogModel.fromFirestore(DocumentSnapshot snapshot)
  {

    return TechnicalBlogModel(
      title: snapshot.get('BLOG TITLE'),
      description: snapshot.get('BLOG DESCRIPTION'),
      thumbnail: snapshot.get('BLOG IMAGE'),
      loves: snapshot.get('LOVES'),
      blogLink: snapshot.get('BLOG LINK'),
      date: snapshot.get('DATE'),
      timestamp: snapshot.get('TIMESTAMP'),
    );
  }
}
