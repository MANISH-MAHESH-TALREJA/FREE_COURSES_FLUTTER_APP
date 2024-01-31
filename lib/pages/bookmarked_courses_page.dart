import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:blog/bloc/bookmark_bloc.dart';
import 'package:blog/bloc/authentication_bloc.dart';
import 'package:provider/provider.dart';
import '../bloc/theme_bloc.dart';
import '../utility/md2_tab_indicator.dart';
import 'empty_page.dart';
import 'package:blog/utility/list_cards.dart';
import 'package:blog/utility/loading_cards.dart';
import '../widgets/technical_blog_card.dart';

class BookmarkedCoursesPage extends StatefulWidget {
  const BookmarkedCoursesPage({super.key});

  @override
  BookmarkedCoursesPageState createState() => BookmarkedCoursesPageState();
}

class BookmarkedCoursesPageState extends State<BookmarkedCoursesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AuthenticationBLOC sb = context.watch<AuthenticationBLOC>();

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        //backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('MY SAVED COURSES', style: TextStyle(color: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.black),),
          centerTitle: true,
          bottom: TabBar(
              labelPadding: const EdgeInsets.all(0),
              indicatorColor: Theme.of(context).primaryColor,
              isScrollable: false,
              labelColor: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.black,
              unselectedLabelColor: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.grey[500],
              indicatorWeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(
                  fontFamily: 'Muli',
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
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    alignment: Alignment.center,
                    child: const Text('FREE COURSES'),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    alignment: Alignment.center,
                    child: const Text('VIDEO COURSES'),
                  ),
                )
              ]),
        ),
        body: TabBarView(children: <Widget>[
          sb.guestUser == true
              ? const EmptyPage(
                  icon: Feather.user_plus,
                  message: 'SIGN IN FIRST',
                  message1: "SIGN IN TO SAVE YOUR FAVORITE COURSES HERE.",
                )
              : const BookmarkedUdemyCourses(),
          sb.guestUser == true
              ? const EmptyPage(
                  icon: Feather.user_plus,
                  message: 'SIGN UP FIRST',
                  message1: "SIGN UP TO SAVE YOUR FAVORITE VIDEOS HERE.",
                )
              : const BookMarkedVideoCourses(),
        ]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BookmarkedUdemyCourses extends StatefulWidget {
  const BookmarkedUdemyCourses({super.key});

  @override
  BookmarkedUdemyCoursesState createState() => BookmarkedUdemyCoursesState();
}

class BookmarkedUdemyCoursesState extends State<BookmarkedUdemyCourses>
    with AutomaticKeepAliveClientMixin {
  final String collectionName = 'UDEMY COURSES';
  final String type = 'BOOKMARKED UDEMY COURSES';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: context.watch<BookmarkBLOC>().getPlaceData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return const EmptyPage(
              icon: Feather.bookmark,
              message: 'NO COURSES FOUND',
              message1: 'SAVE YOUR FAVORITE COURSES HERE.',
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(5),
              itemCount: snapshot.data.length,
              separatorBuilder: (context, index) => const SizedBox(
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
        }
        return ListView.separated(
          padding: const EdgeInsets.all(15),
          itemCount: 5,
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: 10,
          ),
          itemBuilder: (BuildContext context, int index) {
            return const LoadingCard(height: 150);
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BookMarkedVideoCourses extends StatefulWidget {
  const BookMarkedVideoCourses({super.key});

  @override
  BookMarkedVideoCoursesState createState() => BookMarkedVideoCoursesState();
}

class BookMarkedVideoCoursesState extends State<BookMarkedVideoCourses>
    with AutomaticKeepAliveClientMixin {
  final String collectionName = 'YOUTUBE VIDEO COURSES';
  final String type = 'BOOKMARKED YOUTUBE COURSES';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: context.watch<BookmarkBLOC>().getBlogData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return const EmptyPage(
              icon: Feather.bookmark,
              message: 'NO VIDEO COURSES FOUND',
              message1: 'SAVE YOUR FAVORITE VIDEO COURSES HERE.',
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(5),
              itemCount: snapshot.data.length,
              separatorBuilder: (context, index) => const SizedBox(
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
        }
        return ListView.separated(
          padding: const EdgeInsets.all(15),
          itemCount: 5,
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: 10,
          ),
          itemBuilder: (BuildContext context, int index) {
            return const LoadingCard(height: 120);
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

