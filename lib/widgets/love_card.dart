import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blog/bloc/authentication_bloc.dart';
import 'package:blog/utility/general_utility_classes.dart';
import 'package:provider/provider.dart';

class LoveCard extends StatelessWidget
{
  final String collectionName;
  final String? uid;
  final String timestamp;

  const LoveCard({super.key, required this.collectionName, required this.uid, required this.timestamp});

  @override
  Widget build(BuildContext context)
  {
    final sb = context.watch<AuthenticationBLOC>();
    String type = collectionName == 'UDEMY COURSES' ? 'LOVED UDEMY COURSES' : 'LOVED YOUTUBE COURSES';
    if (sb.isSignedIn == false) return LoveIcon().normal;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('USERS').doc(uid).snapshots(),
      builder: (context, snap)
      {
        if (uid == null) return LoveIcon().normal;
        if (!snap.hasData) return LoveIcon().normal;
        List d = snap.data![type];

        if (d.contains(timestamp))
        {
          return LoveIcon().bold;
        }
        else
        {
          return LoveIcon().normal;
        }
      },
    );
  }
}
