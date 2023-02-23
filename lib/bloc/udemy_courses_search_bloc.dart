import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blog/models/udemy_courses_model.dart';

class UdemyCoursesSearchBLOC with ChangeNotifier
{
  UdemyCoursesSearchBLOC()
  {
    getRecentSearchList();
  }

  List<String> _recentSearchData = [];
  List<String> get recentSearchData => _recentSearchData;
  String _searchText = '';
  String get searchText => _searchText;
  bool _searchStarted = false;
  bool get searchStarted => _searchStarted;
  TextEditingController _textFieldCtrl = TextEditingController();
  TextEditingController get textFieldCtrl => _textFieldCtrl;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future getRecentSearchList() async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData = sp.getStringList('RECENT SEARCH DATA') ?? [];
    notifyListeners();
  }

  Future addToSearchList(String value) async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData.add(value);
    await sp.setStringList('RECENT SEARCH DATA', _recentSearchData);
    notifyListeners();
  }

  Future removeFromSearchList(String value) async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData.remove(value);
    await sp.setStringList('RECENT SEARCH DATA', _recentSearchData);
    notifyListeners();
  }

  Future<List> getData() async
  {
    List<UdemyCoursesModel> data = [];
    QuerySnapshot rawData = await fireStore.collection('UDEMY COURSES').orderBy('TIMESTAMP', descending: true).get();
    List<DocumentSnapshot> _snap = [];
    _snap.addAll(rawData.docs.where((u) => (u['COURSE NAME'].toLowerCase().contains(_searchText.toLowerCase()) || u['DESCRIPTION'].toLowerCase().contains(_searchText.toLowerCase()))));
    data = _snap.map((e) => UdemyCoursesModel.fromFirestore(e)).toList();
    return data;
  }

  setSearchText(value)
  {
    _textFieldCtrl.text = value;
    _searchText = value;
    _searchStarted = true;
    notifyListeners();
  }

  searchInitialize()
  {
    _textFieldCtrl.clear();
    _searchStarted = false;
    notifyListeners();
  }
}
