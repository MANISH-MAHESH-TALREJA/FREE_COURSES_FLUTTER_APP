import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blog/MODELS/UdemyCoursesModel.dart';
import 'package:blog/MODELS/VideoCoursesModel.dart';

class BookmarkBLOC extends ChangeNotifier
{
  Future<List> getPlaceData() async
  {
    String collectionName = 'UDEMY COURSES';
    String type = 'BOOKMARKED UDEMY COURSES';
    List<UdemyCoursesModel> data = [];
    List<DocumentSnapshot> _snap = [];

    SharedPreferences sp = await SharedPreferences.getInstance();
    String? _uid = sp.getString('UID');
    final DocumentReference ref = FirebaseFirestore.instance.collection('USERS').doc(_uid);
    DocumentSnapshot snap = await ref.get();
    List d = snap[type];

    if (d.isNotEmpty)
    {
      QuerySnapshot rawData = await FirebaseFirestore.instance.collection(collectionName).where('TIMESTAMP', whereIn: d).get();
      _snap.addAll(rawData.docs);
      data = _snap.map((e) => UdemyCoursesModel.fromFirestore(e)).toList();
    }

    return data;
  }

  Future<List> getBlogData() async
  {
    String collectionName = 'YOUTUBE VIDEO COURSES';
    String type = 'BOOKMARKED YOUTUBE COURSES';
    List<VideoCoursesModel> data = [];
    List<DocumentSnapshot> _snap = [];
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? _uid = sp.getString('UID');

    final DocumentReference ref = FirebaseFirestore.instance.collection('USERS').doc(_uid);
    DocumentSnapshot snap = await ref.get();
    List d = snap[type];

    if (d.isNotEmpty)
    {
      QuerySnapshot rawData = await FirebaseFirestore.instance.collection(collectionName).where('TIMESTAMP', whereIn: d).get();
      _snap.addAll(rawData.docs);
      data = _snap.map((e) => VideoCoursesModel.fromFirestore(e)).toList();
    }
    return data;
  }

  Future onBookmarkIconClick(String collectionName, String timestamp) async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? _uid = sp.getString('UID');
    String _type = collectionName == 'UDEMY COURSES' ? 'BOOKMARKED UDEMY COURSES' : 'BOOKMARKED YOUTUBE COURSES';

    final DocumentReference ref = FirebaseFirestore.instance.collection('USERS').doc(_uid);
    DocumentSnapshot snap = await ref.get();
    List d = snap[_type];

    if (d.contains(timestamp))
    {
      List a = [timestamp];
      await ref.update({_type: FieldValue.arrayRemove(a)});
    }
    else
    {
      d.add(timestamp);
      await ref.update({_type: FieldValue.arrayUnion(d)});
    }
    notifyListeners();
  }

  Future onLoveIconClick(String collectionName, String timestamp) async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? _uid = sp.getString('UID');
    String _type = collectionName == 'UDEMY COURSES' ? 'LOVED UDEMY COURSES' : 'LOVED YOUTUBE COURSES';
    final DocumentReference ref = FirebaseFirestore.instance.collection('USERS').doc(_uid);
    final DocumentReference ref1 = FirebaseFirestore.instance.collection(collectionName).doc(timestamp);

    DocumentSnapshot snap = await ref.get();
    DocumentSnapshot snap1 = await ref1.get();
    List d = snap[_type];
    int _loves = snap1['LOVES'];

    if (d.contains(timestamp))
    {
      List a = [timestamp];
      await ref.update({_type: FieldValue.arrayRemove(a)});
      ref1.update({'LOVES': _loves - 1});
    }
    else
    {
      d.add(timestamp);
      await ref.update({_type: FieldValue.arrayUnion(d)});
      ref1.update({'LOVES': _loves + 1});
    }
  }
}
