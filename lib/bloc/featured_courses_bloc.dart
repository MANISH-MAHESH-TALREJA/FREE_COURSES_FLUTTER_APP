import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:blog/models/udemy_courses_model.dart';

class FeaturedCoursesBLOC with ChangeNotifier
{
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List<UdemyCoursesModel> _data = [];

  List<UdemyCoursesModel> get data => _data;

  List featuredList = [];

  Future<List> _getFeaturedList() async
  {
    final DocumentReference ref = fireStore.collection('FEATURED COURSES').doc('COURSES');
    DocumentSnapshot snap = await ref.get();
    featuredList = snap['UDEMY COURSES'] ?? [];
    return featuredList;
  }

  Future getData() async
  {
    _getFeaturedList().then((featuredList) async
    {
      QuerySnapshot rawData;
      rawData = await fireStore.collection('UDEMY COURSES').where('TIMESTAMP', whereIn: featuredList,).limit(5).get();
      List<DocumentSnapshot> snap = [];
      snap.addAll(rawData.docs);
      _data = snap.map((e) => UdemyCoursesModel.fromFirestore(e)).toList();
      notifyListeners();
    });
  }

  onRefresh()
  {
    featuredList.clear();
    _data.clear();
    getData();
    notifyListeners();
  }
}
