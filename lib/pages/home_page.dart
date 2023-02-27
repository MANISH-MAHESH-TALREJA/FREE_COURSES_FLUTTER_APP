import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:blog/bloc/notification_bloc.dart';
import 'package:blog/pages/technical_blog_page.dart';
import 'package:blog/pages/bookmarked_courses_page.dart';
import 'package:blog/pages/explore_courses.dart';
import 'package:blog/pages/profile_page.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:blog/pages/course_categories_page.dart';
import 'package:blog/pages/video_courses_page.dart';
import 'package:toast/toast.dart';

import '../bloc/theme_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>  with TickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  List<IconData> iconList = [
    Feather.home,
    Feather.youtube,
    Feather.grid,
    Feather.book_open,
    Feather.bookmark,
    Feather.user
  ];
  DateTime? currentBackPressTime;
  Future<bool> onWillPop()
  {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2))
    {
      currentBackPressTime = now;
      Toast.show("PRESS BACK BUTTON AGAIN TO EXIT", duration: Toast.lengthShort, gravity:  Toast.bottom);
      return Future.value(false);
    }
    return Future.value(true);
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(index,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 400));
  }

  AppUpdateInfo? _updateInfo;
  Future<void> checkForUpdate() async
  {
    InAppUpdate.checkForUpdate().then((info)
    {
      setState(()
      {
        _updateInfo = info;
      });
      debugPrint(_updateInfo.toString());
    }).catchError((e)
    {
      debugPrint(e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    askPermission();
    checkForUpdate();
    Future.delayed(const Duration(milliseconds: 0)).then((value) async {
      await context
          .read<NotificationBLOC>()
          .initFirebasePushNotification(context);
    });
  }

  void askPermission() async
  {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    late final Map<Permission, PermissionStatus> status;
    if (androidInfo.version.sdkInt > 32)
    {
      status = await [Permission.notification].request();
    }
    status.forEach((permission, status)
    {
      if (status != PermissionStatus.granted)
      {
      }
    });
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: context.watch<ThemeBloc>().darkTheme! == true ? Colors.grey[900] : Colors.white,
        icons: iconList,
        shadow: null,
        notchAndCornersAnimation: CurvedAnimation(
          parent: AnimationController(
            duration: const Duration(milliseconds: 500),
            vsync: this,
          ),
          curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
        ),
        splashColor: Colors.red,
        splashRadius: 10,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        activeIndex: _currentIndex,
        inactiveColor: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.grey[800],
        activeColor: context.watch<ThemeBloc>().darkTheme! == true ? Colors.cyanAccent : Theme.of(context).accentColor,
        onTap: (index) => onTabTapped(index),
        gapLocation: GapLocation.none,
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const <Widget>[
            ExploreCourses(),
            VideoCoursesPage(),
            CourseCategoriesPage(),
            TechnicalBlogPage(),
            BookmarkedCoursesPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}
