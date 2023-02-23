import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blog/MODELS/CourseCategoriesModel.dart';

class CourseCategoryBLOC extends ChangeNotifier
{
  DocumentSnapshot? _lastVisible;
  DocumentSnapshot? get lastVisible => _lastVisible;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  List<CourseCategoriesModel> _data = [];
  List<CourseCategoriesModel> get data => _data;
  List<DocumentSnapshot> _snap = [];
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool? _hasData;
  bool? get hasData => _hasData;

  Future<Null> getData(mounted) async
  {
    _hasData = true;
    QuerySnapshot rawData;

    if (_lastVisible == null)
      rawData = await fireStore.collection('COURSE CATEGORIES').orderBy('TIMESTAMP', descending: true).limit(10).get();
    else
      rawData = await fireStore.collection('COURSE CATEGORIES').orderBy('TIMESTAMP', descending: true).startAfter([_lastVisible!['TIMESTAMP']]).limit(10).get();

    if (rawData != null && rawData.docs.length > 0)
    {
      _lastVisible = rawData.docs[rawData.docs.length - 1];
      if (mounted)
      {
        _isLoading = false;
        _snap.addAll(rawData.docs);
        _data = _snap.map((e) => CourseCategoriesModel.fromFirestore(e)).toList();
      }
    }
    else
    {
      if (_lastVisible == null)
      {
        _isLoading = false;
        _hasData = false;
      }
      else
      {
        _isLoading = false;
        _hasData = true;
      }
    }
    notifyListeners();
    return null;
  }

  setLoading(bool isLoading)
  {
    _isLoading = isLoading;
    notifyListeners();
  }

  onRefresh(mounted)
  {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    //_lastVisible = null;
    getData(mounted);
    notifyListeners();
  }

  onReload(mounted)
  {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    //_lastVisible = null;
    getData(mounted);
    notifyListeners();
  }
}
