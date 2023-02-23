import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/BLOC/FeaturedCoursesBLOC.dart';
import 'package:blog/BLOC/PopularCoursesBLOC.dart';
import 'package:blog/BLOC/RecentCoursesBLOC.dart';
import 'package:blog/BLOC/RecommendedCoursesBLOC.dart';
import 'package:blog/BLOC/authentication_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:blog/PAGES/ProfilePage.dart';
import 'package:blog/PAGES/UdemyCoursesSearchPage.dart';
import 'package:blog/UTILITY/GeneralUtilityFunctions.dart';
import 'package:blog/WIDGETS/FeaturedCourses.dart';
import 'package:blog/WIDGETS/PopularCourses.dart';
import 'package:blog/WIDGETS/RecentCourses.dart';
import 'package:blog/WIDGETS/RecommendedCourses.dart';
import '../Constants.dart';

class ExploreCourses extends StatefulWidget {
  ExploreCourses({Key? key}) : super(key: key);

  _ExploreCoursesState createState() => _ExploreCoursesState();
}

class _ExploreCoursesState extends State<ExploreCourses> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((_) {
      context.read<FeaturedCoursesBLOC>().getData();
      context.read<PopularCoursesBLOC>().getData();
      context.read<RecentCoursesBLOC>().getData();
      context.read<RecommendedCoursesBLOC>().getData();
    });
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);
    return Scaffold(
        //backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<FeaturedCoursesBLOC>().onRefresh();
              context.read<PopularCoursesBLOC>().onRefresh(mounted);
              context.read<RecentCoursesBLOC>().onRefresh(mounted);
              context.read<RecommendedCoursesBLOC>().onRefresh(mounted);
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Header(),
                  FeaturedCourses(),
                  PopularCourses(),
                  RecentCourses(),
                  RecommendedCourses()
                ],
              ),
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthenticationBLOC sb = Provider.of<AuthenticationBLOC>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Constants().appName,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey[800]),
                  ),
                  Text(
                    'EXPLORE COURSES',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]),
                  )
                ],
              ),
              Spacer(),
              InkWell(
                child: sb.imageUrl == null || sb.isSignedIn == false
                    ? Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person, size: 28),
                      )
                    : Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(sb.imageUrl!),
                                fit: BoxFit.cover)),
                      ),
                onTap: () {
                  nextScreen(context, ProfilePage());
                },
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
          InkWell(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 5, right: 5),
              padding: EdgeInsets.only(left: 15, right: 15),
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[300]!, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Feather.search,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'SEARCH COURSES',
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UdemyCoursesSearchPage()));
            },
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Constants().appName,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700]),
              ),
              Text(
                'EXPLORE ${Constants().countryName}',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]),
              )
            ],
          ),
          Spacer(),
          IconButton(
              icon: Icon(
                Feather.bell,
                size: 20,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Feather.search,
                size: 20,
              ),
              onPressed: () {})
        ],
      ),
    );
  }
}
