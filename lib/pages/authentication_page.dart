import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/bloc/internet_bloc.dart';
import 'package:blog/bloc/authentication_bloc.dart';
import 'package:blog/utility/general_utility_functions.dart';
import 'introduction_screen.dart';

class AuthenticationPage extends StatefulWidget
{
  final String? tag;

  const AuthenticationPage({Key? key, this.tag}) : super(key: key);

  @override
  AuthenticationPageState createState() => AuthenticationPageState();
}

class AuthenticationPageState extends State<AuthenticationPage>
{
  bool googleSignInStarted = false;
  bool facebookSignInStarted = false;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  handleSkip()
  {
    final sb = context.read<AuthenticationBLOC>();
    sb.setGuestUser();
    sb.removeSignIn();
    nextScreenReplace(context, const IntroductionScreenPage());
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
      nextScreenReplace(context, const IntroductionScreenPage());
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
        //backgroundColor: Theme.of(context).backgroundColor,
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            widget.tag != null
                ? Container()
                : TextButton(
                onPressed: () => handleSkip(),
                child: const Text('SKIP',
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
                  children: const [
                    Text(
                      'WELCOME TO',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'FREE ONLINE COURSES',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Text(
                        'BEST APP TO GET FREE ONLINE COURSES',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                  glowColor: Theme.of(context).accentColor,
                  endRadius: 90.0,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage("assets/images/app_icon.png")),
                ),
                SizedBox(height: size.height * 0.05),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
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
                            children: const [
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
                              : const Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
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
                            children: const [
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
                              : const Center(
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
                          color: Theme.of(context).secondaryHeaderColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'FREE ONLINE COURSES',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).accentColor),
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
                    const AvatarGlow(
                      glowColor: Colors.purpleAccent,
                      endRadius: 90.0,
                      duration: Duration(milliseconds: 2000),
                      repeat: true,
                      repeatPauseDuration: Duration(milliseconds: 100),
                      child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage("assets/images/app_icon.png")),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
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
                                children: const [
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
                                  : const Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: Colors.white),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
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
                                children: const [
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
                                  : const Center(
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
