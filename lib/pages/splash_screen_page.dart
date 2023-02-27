import 'dart:async';
import 'package:blog/bloc/authentication_bloc.dart';
import 'package:blog/pages/authentication_page.dart';
import 'package:blog/utility/general_utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class SplashScreenPage extends StatefulWidget
{
  const SplashScreenPage({super.key});

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage> with SingleTickerProviderStateMixin
{
  var _visible = true;
  AnimationController? animationController;
  Animation<double>? animation;
  startTime() async
  {
    var duration = const Duration(seconds: 5);
    return Timer(duration, afterSplash);
  }
  gotoHomePage()
  {
    final AuthenticationBLOC sb = context.read<AuthenticationBLOC>();
    if (sb.isSignedIn == true)
    {
      sb.getDataFromSp();
    }
    nextScreenReplace(context, const HomePage());
  }

  gotoSignInPage()
  {
    nextScreenReplace(context, const AuthenticationPage());
  }
  afterSplash()
  {
    final AuthenticationBLOC sb = context.read<AuthenticationBLOC>();
    Future.delayed(const Duration(milliseconds: 500)).then((value)
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
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = CurvedAnimation(parent: animationController!, curve: Curves.easeOut);

    animation!.addListener(() => setState(() {}));
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>
          [
            Image.asset(
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
