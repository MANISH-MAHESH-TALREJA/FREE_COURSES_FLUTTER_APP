import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blog/models/udemy_courses_model.dart';

class RecentCoursesBLOC extends ChangeNotifier
{
  List<UdemyCoursesModel> _data = [];
  List<UdemyCoursesModel> get data => _data;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future getData() async
  {
    QuerySnapshot rawData;
    rawData = await fireStore.collection('UDEMY COURSES').orderBy('TIMESTAMP', descending: true).limit(10).get();
    List<DocumentSnapshot> snap = [];
    snap.addAll(rawData.docs);
    _data = snap.map((e) => UdemyCoursesModel.fromFirestore(e)).toList();
    notifyListeners();
  }

  onRefresh(mounted)
  {
    _data.clear();
    getData();
    notifyListeners();
  }
}
