import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:blog/BLOC/TechnicalBlogBLOC.dart';
import 'package:blog/BLOC/bookmark_bloc.dart';
import 'package:blog/BLOC/FeaturedCoursesBLOC.dart';
import 'package:blog/BLOC/InternetBLOC.dart';
import 'package:blog/BLOC/NotificationBLOC.dart';
import 'package:blog/BLOC/PopularCoursesBLOC.dart';
import 'package:blog/BLOC/RecentCoursesBLOC.dart';
import 'package:blog/BLOC/RecommendedCoursesBLOC.dart';
import 'package:blog/BLOC/UdemyCoursesSearchBLOC.dart';
import 'package:blog/BLOC/authentication_bloc.dart';
import 'package:blog/BLOC/CourseCategoryBLOC.dart';
import 'BLOC/VideoCoursesBLOC.dart';
import 'BLOC/VideoCoursesSearchBLOC.dart';
import 'PAGES/SplashScreenPage.dart';


/*class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}*/

void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark
  ));
  //HttpOverrides.global = new MyHttpOverrides();
  //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness:Brightness.dark));
  runApp(MyApp());
}

class MyApp extends StatefulWidget
{
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
{
  /*AppUpdateInfo _updateInfo;
  Future<void> checkForUpdate() async
  {
    InAppUpdate.checkForUpdate().then((info)
    {
      setState(()
      {
        _updateInfo = info;
      });
      print(_updateInfo);
    }).catchError((e)
    {
      print(e.toString());
    });
  }*/


  @override
  void initState() {
    super.initState();
    //checkForUpdate();
  }

  @override
  Widget build(BuildContext context)
  {
    return MultiProvider(
      providers:
      [
        ChangeNotifierProvider<TechnicalBlogBLOC>( create: (context) => TechnicalBlogBLOC()),
        ChangeNotifierProvider<VideoCoursesBLOC>( create: (context) => VideoCoursesBLOC()),
        ChangeNotifierProvider<InternetBLOC>(create: (context) => InternetBLOC()),
        ChangeNotifierProvider<AuthenticationBLOC>(create: (context) => AuthenticationBLOC()),
        ChangeNotifierProvider<BookmarkBLOC>(create: (context) => BookmarkBLOC()),
        ChangeNotifierProvider<PopularCoursesBLOC>(create: (context) => PopularCoursesBLOC()),
        ChangeNotifierProvider<RecentCoursesBLOC>(create: (context) => RecentCoursesBLOC()),
        ChangeNotifierProvider<RecommendedCoursesBLOC>(create: (context) => RecommendedCoursesBLOC()),
        ChangeNotifierProvider<FeaturedCoursesBLOC>(create: (context) => FeaturedCoursesBLOC()),
        ChangeNotifierProvider<UdemyCoursesSearchBLOC>(create: (context) => UdemyCoursesSearchBLOC()),
        ChangeNotifierProvider<VideoCoursesSearchBLOC>(create: (context) => VideoCoursesSearchBLOC()),
        ChangeNotifierProvider<NotificationBLOC>(create: (context) => NotificationBLOC()),
        ChangeNotifierProvider<CourseCategoryBLOC>(create: (context) => CourseCategoryBLOC()),
      ],
      child: MaterialApp(
          theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Colors.blueAccent,
              iconTheme: IconThemeData(color: Colors.grey[900]),
              fontFamily: 'Muli',
              appBarTheme: AppBarTheme(
                color: Colors.transparent,
                elevation: 0,
                brightness: Brightness.light,
                iconTheme: IconThemeData(
                  color: Colors.grey[800],
                ),
                textTheme: TextTheme(
                    headline6: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w500
                    )),
              )),
          debugShowCheckedModeBanner: false,
          home: SplashScreenPage()),
    );
  }
}

