import 'package:cloud_firestore/cloud_firestore.dart';

class VideoCoursesModel
{
  String? title;
  String? description;
  String? thumbnail;
  int? loves;
  String? videoID;
  String? channel;
  String? date;
  String? timestamp;

  VideoCoursesModel({this.title, this.description, this.thumbnail, this.loves, this.videoID, this.channel, this.date, this.timestamp});

  factory VideoCoursesModel.fromFirestore(DocumentSnapshot snapshot)
  {
    return VideoCoursesModel(
      title: snapshot.get('COURSE NAME'),
      description: snapshot.get('COURSE DESCRIPTION'),
      thumbnail: snapshot.get('COURSE IMAGE'),
      loves: snapshot.get('LOVES'),
      videoID: snapshot.get('YOUTUBE VIDEO ID'),
      channel: snapshot.get('CHANNEL'),
      date: snapshot.get('DATE'),
      timestamp: snapshot.get('TIMESTAMP'),
    );
  }
}