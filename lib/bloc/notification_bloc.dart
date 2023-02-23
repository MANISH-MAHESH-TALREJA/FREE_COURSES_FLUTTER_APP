import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blog/models/notification_model.dart';
import 'package:blog/pages/notifications_page.dart';
import 'package:blog/utility/general_utility_functions.dart';

class NotificationBLOC extends ChangeNotifier
{
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  DocumentSnapshot? _lastVisible;

  DocumentSnapshot? get lastVisible => _lastVisible;
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<NotificationModel> _data = [];

  List<NotificationModel> get data => _data;
  bool? _subscribed;

  bool? get subscribed => _subscribed;
  final String subscriptionTopic = 'ALL';

  Future<Null> getData(mounted) async
  {
    QuerySnapshot rawData;
    if (_lastVisible == null)
      rawData = await fireStore.collection('NOTIFICATIONS').orderBy('TIMESTAMP', descending: true).limit(10).get();
    else
      rawData = await fireStore.collection('NOTIFICATIONS').orderBy('TIMESTAMP', descending: true).startAfter([_lastVisible!['TIMESTAMP']]).limit(10).get();

    if (rawData != null && rawData.docs.length > 0)
    {
      _lastVisible = rawData.docs[rawData.docs.length - 1];
      if (mounted)
      {
        _isLoading = false;
        _snap.addAll(rawData.docs);
        _data = _snap.map((e) => NotificationModel.fromFirestore(e)).toList();
      }
    }
    else
    {
      _isLoading = false;
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
    _lastVisible = null;
    getData(mounted);
    notifyListeners();
  }

  onReload(mounted)
  {
    _isLoading = true;
    _snap.clear();
    _data.clear();
    _lastVisible = null;
    getData(mounted);
    notifyListeners();
  }

  Future initFirebasePushNotification(context) async
  {
    handleFcmSubscription();
    FirebaseMessaging.onMessage.listen((RemoteMessage message)
    {
      showInAppDialog(context, message.notification!.title, message.notification);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message)
    {
      nextScreen(context, NotificationsPage());
    });
    notifyListeners();
  }

  Future handleFcmSubscription() async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool _getSubscription = sp.getBool('SUBSCRIBE') ?? true;
    if (_getSubscription == true)
    {
      await sp.setBool('SUBSCRIBE', true);
      _fcm.subscribeToTopic(subscriptionTopic);
      _subscribed = true;
    }
    else
    {
      await sp.setBool('SUBSCRIBE', false);
      _fcm.unsubscribeFromTopic(subscriptionTopic);
      _subscribed = false;
    }
    notifyListeners();
  }

  Future fcmSubscribe(bool isSubscribed) async
  {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('SUBSCRIBE', isSubscribed);
    handleFcmSubscription();
  }

  showInAppDialog(context, title, body)
  {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(title),
          subtitle: HtmlWidget(body)
        ),
        actions: <Widget>[
          TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                nextScreen(context, NotificationsPage());
              }),
        ],
      ),
    );
  }
}
