import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class InternetBLOC extends ChangeNotifier
{
  bool _hasInternet = false;

  InternetBLOC()
  {
    checkInternet();
  }

  set hasInternet(newVal)
  {
    _hasInternet = newVal;
  }

  bool get hasInternet => _hasInternet;

  checkInternet() async
  {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none)
    {
      _hasInternet = false;
    }
    else
    {
      _hasInternet = true;
    }
    notifyListeners();
  }
}
