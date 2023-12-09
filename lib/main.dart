import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'bloc/theme_bloc.dart';
import 'bloc/video_courses_bloc.dart';
import 'bloc/video_courses_search_bloc.dart';
import 'models/theme_model.dart';
import 'pages/splash_screen_page.dart';

void main()async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark
  ));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget
{
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp>
{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider<ThemeBloc>(
        create: (_) => ThemeBloc(),
        child: Consumer<ThemeBloc>(
        builder: (_, mode, child){
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
          darkTheme: ThemeModel().darkMode,
          themeMode: mode.darkTheme == true ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              primaryColor: Colors.blueAccent,
              iconTheme: IconThemeData(color: Colors.grey[900]),
              fontFamily: 'Muli',

              appBarTheme: AppBarTheme(
                color: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(
                  color: Colors.grey[800],
                ),
                titleTextStyle: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w500
                ),
                toolbarTextStyle: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w500
                    ), systemOverlayStyle: SystemUiOverlayStyle.dark,
              )),
          debugShowCheckedModeBanner: false,
          home: const SplashScreenPage()),
      );
        },
        ),
    );
  }
}

