import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:blog/BLOC/NotificationBLOC.dart';
import 'package:blog/PAGES/TechnicalBlogPage.dart';
import 'package:blog/PAGES/BookmarkedCoursesPage.dart';
import 'package:blog/PAGES/ExploreCourses.dart';
import 'package:blog/PAGES/ProfilePage.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:blog/PAGES/CourseCategoriesPage.dart';
import 'package:blog/PAGES/VideoCoursesPage.dart';
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
    checkForUpdate();
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      await context
          .read<NotificationBLOC>()
          .initFirebasePushNotification(context);
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
