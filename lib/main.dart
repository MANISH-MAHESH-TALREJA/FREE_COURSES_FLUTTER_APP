import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:blog/bloc/technical_blog_bloc.dart';
import 'package:blog/bloc/bookmark_bloc.dart';
import 'package:blog/bloc/featured_courses_bloc.dart';
import 'package:blog/bloc/internet_bloc.dart';
import 'package:blog/bloc/notification_bloc.dart';
import 'package:blog/bloc/popular_courses_bloc.dart';
import 'package:blog/bloc/recent_courses_bloc.dart';
import 'package:blog/bloc/recommended_courses_bloc.dart';
import 'package:blog/bloc/udemy_courses_search_bloc.dart';
import 'package:blog/bloc/authentication_bloc.dart';
import 'package:blog/bloc/course_category_bloc.dart';
import 'bloc/video_courses_bloc.dart';
import 'bloc/video_courses_search_bloc.dart';
import 'pages/splash_screen_page.dart';

void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark
  ));
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

  @override
  void initState() {
    super.initState();
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
              fontFamily: 'Poppins',
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

