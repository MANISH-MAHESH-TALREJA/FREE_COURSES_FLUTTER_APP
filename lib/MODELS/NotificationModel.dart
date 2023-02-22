import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationModel
{
  String title;
  String description;
  var createdAt;
  String timestamp;

  NotificationModel({this.title, this.description, this.createdAt, this.timestamp});

  factory NotificationModel.fromFirestore(DocumentSnapshot snapshot)
  {
    Map<String, dynamic> d = snapshot.data();
    return NotificationModel(
      title: d['TITLE'],
      description: d['DESCRIPTION'],
      createdAt: DateFormat('d MMM, y').format(DateTime.parse(d['CREATED AT'].toDate().toString())),
      timestamp: d['TIMESTAMP'],
    );
  }
}