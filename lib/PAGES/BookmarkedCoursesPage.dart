import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:blog/BLOC/BookmarkBLOC.dart';
import 'package:blog/BLOC/AuthenticationBLOC.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:provider/provider.dart';
import 'EmptyPage.dart';
import 'package:blog/UTILITY/ListCards.dart';
import 'package:blog/UTILITY/LoadingCards.dart';
import '../widgets/TechnicalBlogCard.dart';

class BookmarkedCoursesPage extends StatefulWidget {
  const BookmarkedCoursesPage({Key key}) : super(key: key);

  @override
  _BookmarkedCoursesPageState createState() => _BookmarkedCoursesPageState();
}

class _BookmarkedCoursesPageState extends State<BookmarkedCoursesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AuthenticationBLOC sb = context.watch<AuthenticationBLOC>();

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('MY SAVED COURSES'),
          centerTitle: true,
          bottom: TabBar(
              labelPadding: EdgeInsets.all(0),
              indicatorColor: Theme.of(context).primaryColor,
              isScrollable: false,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[500],
              indicatorWeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
              indicator: MD2Indicator(
                indicatorHeight: 2,
                indicatorSize: MD2IndicatorSize.normal,
                indicatorColor: Theme.of(context).primaryColor,
              ),
              tabs: [
                Tab(
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    alignment: Alignment.center,
                    child: Text('FREE COURSES'),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    alignment: Alignment.center,
                    child: Text('VIDEO COURSES'),
                  ),
                )
              ]),
        ),
        body: TabBarView(children: <Widget>[
          sb.guestUser == true
              ? EmptyPage(
                  icon: Feather.user_plus,
                  message: 'SIGN IN FIRST',
                  message1: "SIGN IN TO SAVE YOUR FAVORITE COURSES HERE.",
                )
              : BookmarkedUdemyCourses(),
          sb.guestUser == true
              ? EmptyPage(
                  icon: Feather.user_plus,
                  message: 'SIGN UP FIRST',
                  message1: "SIGN UP TO SAVE YOUR FAVORITE VIDEOS HERE.",
                )
              : BookMarkedVideoCourses(),
        ]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BookmarkedUdemyCourses extends StatefulWidget {
  const BookmarkedUdemyCourses({Key key}) : super(key: key);

  @override
  _BookmarkedUdemyCoursesState createState() => _BookmarkedUdemyCoursesState();
}

class _BookmarkedUdemyCoursesState extends State<BookmarkedUdemyCourses>
    with AutomaticKeepAliveClientMixin {
  final String collectionName = 'UDEMY COURSES';
  final String type = 'BOOKMARKED UDEMY COURSES';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: FutureBuilder(
        future: context.watch<BookmarkBLOC>().getPlaceData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return EmptyPage(
                icon: Feather.bookmark,
                message: 'NO COURSES FOUND',
                message1: 'SAVE YOUR FAVORITE COURSES HERE.',
              );
            else
              return ListView.separated(
                padding: EdgeInsets.all(5),
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: 5,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ListCard(
                    d: snapshot.data[index],
                    tag: "BOOKMARK LIST $index",
                    color: Colors.white,
                  );
                },
              );
          }
          return ListView.separated(
            padding: EdgeInsets.all(15),
            itemCount: 5,
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              return LoadingCard(height: 150);
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BookMarkedVideoCourses extends StatefulWidget {
  const BookMarkedVideoCourses({Key key}) : super(key: key);

  @override
  _BookMarkedVideoCoursesState createState() => _BookMarkedVideoCoursesState();
}

class _BookMarkedVideoCoursesState extends State<BookMarkedVideoCourses>
    with AutomaticKeepAliveClientMixin {
  final String collectionName = 'YOUTUBE VIDEO COURSES';
  final String type = 'BOOKMARKED YOUTUBE COURSES';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: FutureBuilder(
        future: context.watch<BookmarkBLOC>().getBlogData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return EmptyPage(
                icon: Feather.bookmark,
                message: 'NO VIDEO COURSES FOUND',
                message1: 'SAVE YOUR FAVORITE VIDEO COURSES HERE.',
              );
            else
              return ListView.separated(
                padding: EdgeInsets.all(5),
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: 5,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return BlogCard(
                    d: snapshot.data[index],
                    tag: "BOOKMARK CARD $index",
                    color: Colors.white,
                  );
                },
              );
          }
          return ListView.separated(
            padding: EdgeInsets.all(15),
            itemCount: 5,
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              return LoadingCard(height: 120);
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

