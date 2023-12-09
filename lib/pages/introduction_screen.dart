import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class IntroductionScreenPage extends StatefulWidget {
  const IntroductionScreenPage({super.key});

  @override
  IntroductionScreenPageState createState() => IntroductionScreenPageState();
}

class IntroductionScreenPageState extends State<IntroductionScreenPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  void initState()
  {
    super.initState();
    checkIsLogin();
  }

  void _onIntroEnd(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ), //MaterialPageRoute
    );
  }
  Future<void> checkIsLogin() async
  {
    String? logged = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logged = prefs.getString("LOGGED");
    if (logged != "" && logged != null)
    {
      if(!mounted)
      {
        return;
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
    else
    {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("LOGGED","TRUE");
    }
  }
  Widget _buildImage(String assetName) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset('assets/images/$assetName.gif', width: 300.0, height: MediaQuery.of(context).size.height*0.5,),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          titleWidget: const Text('FREE COURSES', style: TextStyle(fontFamily:'Muli', fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          bodyWidget: const Text('DAILY NEW FREE ONLINE UDEMY COURSES', style: TextStyle(fontFamily:'Muli', fontSize: 17),textAlign: TextAlign.center,),
          image: _buildImage('courses_01'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: const Text('VIDEO COURSES', style: TextStyle(fontFamily:'Muli', fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          bodyWidget: const Text('WIDE VARIETY OF VIDEO COURSES AVAILABLE', style: TextStyle(fontFamily:'Muli', fontSize: 17),textAlign: TextAlign.center,),
          image: _buildImage('courses_02'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: const Text('IT COURSES', style: TextStyle(fontFamily:'Muli', fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          bodyWidget: const Text('POPULAR PROGRAMMING COURSES TO LEARN AND PRACTICE', style: TextStyle(fontFamily:'Muli', fontSize: 17),textAlign: TextAlign.center,),
          image: _buildImage('courses_03'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      skip: const Text('SKIP'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('DONE', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
