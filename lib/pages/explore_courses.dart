import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/bloc/featured_courses_bloc.dart';
import 'package:blog/bloc/popular_courses_bloc.dart';
import 'package:blog/bloc/recent_courses_bloc.dart';
import 'package:blog/bloc/recommended_courses_bloc.dart';
import 'package:blog/bloc/authentication_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:blog/pages/profile_page.dart';
import 'package:blog/pages/udemy_courses_search_page.dart';
import 'package:blog/utility/general_utility_functions.dart';
import 'package:blog/widgets/featured_courses.dart';
import 'package:blog/widgets/popular_courses.dart';
import 'package:blog/widgets/recent_courses.dart';
import 'package:blog/widgets/recommended_courses.dart';
import '../constants.dart';

class ExploreCourses extends StatefulWidget {
  const ExploreCourses({super.key});

  @override
  ExploreCoursesState createState() => ExploreCoursesState();
}

class ExploreCoursesState extends State<ExploreCourses> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((_) {
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
            child: const SingleChildScrollView(
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
  const Header({super.key});

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
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,),
                  ),
                  const Text(
                    'EXPLORE COURSES',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,),
                  )
                ],
              ),
              const Spacer(),
              InkWell(
                child: sb.imageUrl == null || sb.isSignedIn == false
                    ? Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, size: 28),
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
                  nextScreen(context, const ProfilePage());
                },
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          InkWell(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 5, right: 5),
              padding: const EdgeInsets.only(left: 15, right: 15),
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
                    const SizedBox(
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
                  MaterialPageRoute(builder: (context) => const UdemyCoursesSearchPage()));
            },
          )
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 15),
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
          const Spacer(),
          IconButton(
              icon: const Icon(
                Feather.bell,
                size: 20,
              ),
              onPressed: () {}),
          IconButton(
              icon: const Icon(
                Feather.search,
                size: 20,
              ),
              onPressed: () {})
        ],
      ),
    );
  }
}
