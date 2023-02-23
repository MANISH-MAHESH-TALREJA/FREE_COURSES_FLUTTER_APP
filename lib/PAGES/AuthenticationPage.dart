import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/BLOC/InternetBLOC.dart';
import 'package:blog/BLOC/authentication_bloc.dart';
import 'package:blog/UTILITY/GeneralUtilityFunctions.dart';
import 'IntroductionScreen.dart';

class AuthenticationPage extends StatefulWidget
{
  final String? tag;

  AuthenticationPage({Key? key, this.tag}) : super(key: key);

  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
{
  bool googleSignInStarted = false;
  bool facebookSignInStarted = false;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  handleSkip()
  {
    final sb = context.read<AuthenticationBLOC>();
    sb.setGuestUser();
    sb.removeSignIn();
    nextScreenReplace(context, IntroductionScreenPage());
  }
  handleFacebookSignIn() async
  {
    final sb = context.read<AuthenticationBLOC>();
    final ib = context.read<InternetBLOC>();
    setState(() => facebookSignInStarted = true);
    await ib.checkInternet();
    if (ib.hasInternet == false)
    {
      openSnackBar(scaffoldKey, 'CHECK YOUR INTERNET CONNECTION');
    } else {
      await sb.signInWithFacebook().then((_)
      {
        if (sb.hasError == true)
        {
          openSnackBar(scaffoldKey, 'SOMETHING WRONG, PLEASE TRY AGAIN.');
          setState(() => facebookSignInStarted = false);
        }
        else
        {
          sb.checkUserExists().then((value)
          {
            if (value == true)
            {
              sb.getUserDataFromFirebase(sb.uid).then((value) => sb
                  .saveDataToSP()
                  .then((value) => sb.guestSignOut())
                  .then((value) => sb.setSignIn().then((value)
              {
                setState(() => facebookSignInStarted = false);
                afterSignIn();
              })));
            }
            else
            {
              sb.getJoiningDate().then((value) => sb
                  .saveToFirebase()
                  .then((value) => sb.increaseUserCount())
                  .then((value) => sb.saveDataToSP().then((value) => sb
                  .guestSignOut()
                  .then((value) => sb.setSignIn().then((value)
              {
                setState(() => facebookSignInStarted = false);
                afterSignIn();
              })))));
            }
          });
        }
      });
    }
  }
  handleGoogleSignIn() async
  {
    final sb = context.read<AuthenticationBLOC>();
    final ib = context.read<InternetBLOC>();
    setState(() => googleSignInStarted = true);
    await ib.checkInternet();
    if (ib.hasInternet == false)
    {
      openSnackBar(scaffoldKey, 'CHECK YOUR INTERNET CONNECTION');
    }
    else
    {
      await sb.signInWithGoogle().then((_)
      {
        if (sb.hasError == true)
        {
          openSnackBar(scaffoldKey, 'SOMETHING WRONG, PLEASE TRY AGAIN.');
          setState(() => googleSignInStarted = false);
        }
        else
        {
          sb.checkUserExists().then((value)
          {
            if (value == true)
            {
              sb.getUserDataFromFirebase(sb.uid).then((value) => sb
                  .saveDataToSP()
                  .then((value) => sb.guestSignOut())
                  .then((value) => sb.setSignIn().then((value) {
                        setState(() => googleSignInStarted = false);
                        afterSignIn();
                      })));
            }
            else
            {
              sb.getJoiningDate().then((value) => sb
                  .saveToFirebase()
                  .then((value) => sb.increaseUserCount())
                  .then((value) => sb.saveDataToSP().then((value) => sb
                      .guestSignOut()
                      .then((value) => sb.setSignIn().then((value) {
                            setState(() => googleSignInStarted = false);
                            afterSignIn();
                          })))));
            }
          });
        }
      });
    }
  }

  afterSignIn() {
    if (widget.tag == null) {
      nextScreenReplace(context, IntroductionScreenPage());
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return OrientationBuilder(builder: (context, orientation){
      return Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        appBar: AppBar(
          actions: [
            widget.tag != null
                ? Container()
                : TextButton(
                onPressed: () => handleSkip(),
                child: Text('SKIP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )))
          ],
        ),
        body: orientation==Orientation.portrait? Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME TO',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'FREE ONLINE COURSES',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        'BEST APP TO GET FREE ONLINE COURSES',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[700]),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 3,
                      width: MediaQuery.of(context).size.width * 0.50,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.05),
                AvatarGlow(
                  glowColor: Colors.purpleAccent,
                  endRadius: 90.0,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("assets/images/app_icon.png")),
                ),
                SizedBox(height: size.height * 0.05),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextButton(
                          onPressed: () => handleGoogleSignIn(),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),),
                            backgroundColor: MaterialStateProperty.all(Colors.blueAccent)
                          ),
                          child: googleSignInStarted == false
                              ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesome.google,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'SIGN IN WITH GOOGLE',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )
                            ],
                          )
                              : Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.white),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: TextButton(
                          onPressed: () {
                            handleFacebookSignIn();
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),),
                              backgroundColor: MaterialStateProperty.all(Colors.blueAccent)
                          ),
                          child: facebookSignInStarted == false
                              ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesome.facebook_official,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'SIGN IN WITH FACEBOOK',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )
                            ],
                          )
                              : Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.white),
                          )),
                    ),
                    Container(),
                  ],
                ),
              ],
            ),
          ),
        ): Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME TO',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'FREE ONLINE COURSES',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  height: 3,
                  width: MediaQuery.of(context).size.width * 0.50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(40)),
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    AvatarGlow(
                      glowColor: Colors.purpleAccent,
                      endRadius: 90.0,
                      duration: Duration(milliseconds: 2000),
                      repeat: true,
                      repeatPauseDuration: Duration(milliseconds: 100),
                      child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage("assets/images/app_icon.png")),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: TextButton(
                              onPressed: () => handleGoogleSignIn(),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),),
                                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent)
                              ),
                              child: googleSignInStarted == false
                                  ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesome.google,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'SIGN IN WITH GOOGLE',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )
                                ],
                              )
                                  : Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: Colors.white),
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: TextButton(
                              onPressed: () {
                                handleFacebookSignIn();
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),),
                                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent)
                              ),
                              child: facebookSignInStarted == false
                                  ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesome.facebook_official,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'SIGN IN WITH FACEBOOK',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )
                                ],
                              )
                                  : Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: Colors.white),
                              )),
                        ),
                        Container(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
