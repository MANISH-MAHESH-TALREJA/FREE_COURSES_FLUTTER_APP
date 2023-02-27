import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/bloc/video_courses_search_bloc.dart';
import '../bloc/theme_bloc.dart';
import 'empty_page.dart';
import 'package:blog/utility/list_cards.dart';
import 'package:blog/utility/loading_cards.dart';
import 'package:blog/utility/general_utility_functions.dart';

class VideoCoursesSearchPage extends StatefulWidget {
  const VideoCoursesSearchPage({Key? key}) : super(key: key);

  @override
  VideoCoursesSearchPageState createState() => VideoCoursesSearchPageState();
}

class VideoCoursesSearchPageState extends State<VideoCoursesSearchPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(const Duration())
        .then((value) => context.read<VideoCoursesSearchBLOC>().searchInitialize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 56,
              width: w,
              //decoration: BoxDecoration(color: Colors.white),
              child: TextFormField(
                autofocus: true,
                controller: context.watch<VideoCoursesSearchBLOC>().textFieldCtrl,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "SEARCH COURSES ....",
                  hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 15),
                    child: IconButton(
                      icon: Icon(
                        Icons.keyboard_backspace,
                        color: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.grey[800],
                      ),
                      color: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.grey[800],
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.grey[800],
                      size: 25,
                    ),
                    onPressed: () {
                      context.read<VideoCoursesSearchBLOC>().searchInitialize();
                    },
                  ),
                ),
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (value) {
                  if (value == '') {
                    openSnackBar(scaffoldKey, 'TYPE SOMETHING !!!');
                  } else {
                    context.read<VideoCoursesSearchBLOC>().setSearchText(value);
                    context.read<VideoCoursesSearchBLOC>().addToSearchList(value);
                  }
                },
              ),
            ),
            SizedBox(
              height: 1,
              child: Divider(
                color: Colors.grey[300],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, bottom: 5),
              child: Text(
                context.watch<VideoCoursesSearchBLOC>().searchStarted == false
                    ? 'RECENT SEARCHES'
                    : 'WE HAVE FOUND',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    /*color: Colors.grey[800],*/
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ),
            context.watch<VideoCoursesSearchBLOC>().searchStarted == false
                ? const SuggestionsUI()
                : const AfterSearchUI()
          ],
        ),
      ),
    );
  }
}

class SuggestionsUI extends StatelessWidget {
  const SuggestionsUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<VideoCoursesSearchBLOC>();
    return Expanded(
      child: sb.recentSearchData.isEmpty
          ? const EmptyPage(
              icon: Feather.search,
              message: 'SEARCH FOR COURSES',
              message1: "SEARCH FOR VIDEO COURSES",
            )
          : ListView.builder(
              itemCount: sb.recentSearchData.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    sb.recentSearchData[index],
                    style: const TextStyle(fontSize: 17),
                  ),
                  leading: const Icon(CupertinoIcons.time_solid),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context
                          .read<VideoCoursesSearchBLOC>()
                          .removeFromSearchList(sb.recentSearchData[index]);
                    },
                  ),
                  onTap: () {
                    context
                        .read<VideoCoursesSearchBLOC>()
                        .setSearchText(sb.recentSearchData[index]);
                  },
                );
              },
            ),
    );
  }
}

class AfterSearchUI extends StatelessWidget {
  const AfterSearchUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: context.watch<VideoCoursesSearchBLOC>().getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return const EmptyPage(
                icon: Feather.clipboard,
                message: 'NO COURSES FOUND',
                message1: "TRY AGAIN",
              );
            } else {
              return ListView.separated(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 5,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ListCard2(
                    d: snapshot.data[index],
                    tag: "SEARCH $index",
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
      ),
    );
  }
}
