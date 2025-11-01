//import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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

  Future<void> checkInternet() async
  {
    // The return type is now List<ConnectivityResult>
    final List<ConnectivityResult> result = await Connectivity().checkConnectivity();

    // Check if the list of connectivity results contains 'none'
    if (result.contains(ConnectivityResult.none))
    {
      _hasInternet = false;
    }
    else
    {
      // If it doesn't contain 'none', it means there is some form of connectivity
      _hasInternet = true;
    }
    notifyListeners();
  }
  /*checkInternet() async
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
  }*/
}
