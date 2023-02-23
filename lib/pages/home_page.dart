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

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

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
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2))
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
        curve: Curves.easeIn, duration: Duration(milliseconds: 400));
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
      print(_updateInfo);
    }).catchError((e)
    {
      print(e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    askPermission();
    checkForUpdate();
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
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
        icons: iconList,
        activeIndex: _currentIndex,
        inactiveColor: Colors.grey[800],
        onTap: (index) => onTabTapped(index),
        gapLocation: GapLocation.none,
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
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
