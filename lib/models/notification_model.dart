import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationModel
{
  String? title;
  String? description;
  var createdAt;
  String? timestamp;

  NotificationModel({this.title, this.description, this.createdAt, this.timestamp});

  factory NotificationModel.fromFirestore(DocumentSnapshot snapshot)
  {
    return NotificationModel(
      title: snapshot.get('TITLE'),
      description: snapshot.get('DESCRIPTION'),
      createdAt: DateFormat('d MMM, y').format(DateTime.parse(snapshot.get('CREATED AT').toDate().toString())),
      timestamp: snapshot.get('TIMESTAMP'),
    );
  }
}