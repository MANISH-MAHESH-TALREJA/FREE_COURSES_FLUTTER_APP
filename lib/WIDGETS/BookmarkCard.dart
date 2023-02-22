import 'package:blog/UTILITY/GeneralUtilityClasses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blog/BLOC/AuthenticationBLOC.dart';
import 'package:provider/provider.dart';

class BookmarkCard extends StatelessWidget
{
  final String collectionName;
  final String uid;
  final String timestamp;

  const BookmarkCard({Key key, @required this.collectionName, @required this.uid, @required this.timestamp}): super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final sb = context.watch<AuthenticationBLOC>();
    String _type = collectionName == 'UDEMY COURSES' ? 'BOOKMARKED UDEMY COURSES' : 'BOOKMARKED YOUTUBE COURSES';
    if (sb.isSignedIn == false) return BookmarkIcon().normal;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('USERS').doc(uid).snapshots(),
      builder: (context, snap)
      {
        if (uid == null) return BookmarkIcon().normal;
        if (!snap.hasData) return BookmarkIcon().normal;
        List d = snap.data[_type];
        if (d.contains(timestamp))
        {
          return BookmarkIcon().bold;
        }
        else
        {
          return BookmarkIcon().normal;
        }
      },
    );
  }
}
