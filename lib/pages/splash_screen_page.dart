import 'dart:async';
import 'package:blog/bloc/authentication_bloc.dart';
import 'package:blog/pages/authentication_page.dart';
import 'package:blog/utility/general_utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class SplashScreenPage extends StatefulWidget
{
  @override
  SplashScreenPageState createState() => new SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> with SingleTickerProviderStateMixin
{
  var _visible = true;
  AnimationController? animationController;
  Animation<double>? animation;
  startTime() async
  {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, afterSplash);
  }
  gotoHomePage()
  {
    final AuthenticationBLOC sb = context.read<AuthenticationBLOC>();
    if (sb.isSignedIn == true)
    {
      sb.getDataFromSp();
    }
    nextScreenReplace(context, HomePage());
  }

  gotoSignInPage()
  {
    nextScreenReplace(context, AuthenticationPage());
  }
  afterSplash()
  {
    final AuthenticationBLOC sb = context.read<AuthenticationBLOC>();
    Future.delayed(Duration(milliseconds: 500)).then((value)
    {
      sb.isSignedIn == true || sb.guestUser == true
          ? gotoHomePage()
          : gotoSignInPage();
    });
  }

  @override
  void initState()
  {
    super.initState();
    animationController = new AnimationController(vsync: this, duration: new Duration(seconds: 2));
    animation = new CurvedAnimation(parent: animationController!, curve: Curves.easeOut);

    animation!.addListener(() => this.setState(() {}));
    animationController!.forward();

    setState(()
    {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            new Image.asset(
              'assets/images/app_icon.png',
              width: animation!.value * 250,
              height: animation!.value * 250,
            ),
          ],
        ),
      ),
    );
  }
}
