import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blog/models/technical_blog_model.dart';

class TechnicalBlogBLOC extends ChangeNotifier
{
  DocumentSnapshot? _lastVisible;
  DocumentSnapshot? get lastVisible => _lastVisible;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  List<TechnicalBlogModel> _data = [];
  List<TechnicalBlogModel> get data => _data;
  String _popSelection = 'POPULAR';
  String get popupSelection => _popSelection;
  final List<DocumentSnapshot> _snap = [];
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  bool? _hasData;
  bool? get hasData => _hasData;

  Future<void> getData(mounted, String orderBy) async
  {
    _hasData = true;
    QuerySnapshot rawData;
    if (_lastVisible == null) {
      rawData = await fireStore.collection('TECHNICAL BLOGS').orderBy(orderBy, descending: true).limit(5).get();
    } else {
      rawData = await fireStore.collection('TECHNICAL BLOGS').orderBy(orderBy, descending: true).startAfter([_lastVisible![orderBy]]).limit(5).get();
    }

    if (rawData != null && rawData.docs.isNotEmpty)
    {
      _lastVisible = rawData.docs[rawData.docs.length - 1];
      if (mounted)
      {
        _isLoading = false;
        _snap.addAll(rawData.docs);
        _data = _snap.map((e) => TechnicalBlogModel.fromFirestore(e)).toList();
      }
    }
    else
    {
      if(_lastVisible == null)
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
    return;
  }

  afterPopSelection (value, mounted, orderBy)
  {
    _popSelection = value;
    onRefresh(mounted, orderBy);
    notifyListeners();
  }

  setLoading(bool isLoading)
  {
    _isLoading = isLoading;
    notifyListeners();
  }

  onRefresh(mounted, orderBy)
  {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    _lastVisible = null;
    getData(mounted, orderBy);
    notifyListeners();
  }
}
