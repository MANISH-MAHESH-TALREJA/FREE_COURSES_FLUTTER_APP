import 'package:cloud_firestore/cloud_firestore.dart';

class VideoCoursesModel
{
  String title;
  String description;
  String thumbnail;
  int loves;
  String videoID;
  String channel;
  String date;
  String timestamp;

  VideoCoursesModel({this.title, this.description, this.thumbnail, this.loves, this.videoID, this.channel, this.date, this.timestamp});

  factory VideoCoursesModel.fromFirestore(DocumentSnapshot snapshot)
  {
    Map<String, dynamic> d = snapshot.data();
    return VideoCoursesModel(
      title: d['COURSE NAME'],
      description: d['COURSE DESCRIPTION'],
      thumbnail: d['COURSE IMAGE'],
      loves: d['LOVES'],
      videoID: d['YOUTUBE VIDEO ID'],
      channel: d['CHANNEL'],
      date: d['DATE'],
      timestamp: d['TIMESTAMP'],
    );
  }
}