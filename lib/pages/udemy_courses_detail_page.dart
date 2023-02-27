import 'package:blog/utility/general_utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:line_icons/line_icons.dart';
import 'package:blog/bloc/bookmark_bloc.dart';
import 'package:blog/bloc/authentication_bloc.dart';
import 'package:blog/models/udemy_courses_model.dart';
import 'package:blog/widgets/bookmark_card.dart';
import 'package:blog/widgets/custom_cache_image.dart';
import 'package:blog/widgets/love_count.dart';
import 'package:blog/widgets/love_card.dart';
import 'package:blog/widgets/other_udemy_courses.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../carousel_pro/src/carousel_pro.dart';

class UdemyCoursesDetailPage extends StatefulWidget {
  final UdemyCoursesModel data;
  final String? tag;

  const UdemyCoursesDetailPage({Key? key, required this.data, required this.tag})
      : super(key: key);

  @override
  UdemyCoursesDetailPageState createState() => UdemyCoursesDetailPageState();
}

class UdemyCoursesDetailPageState extends State<UdemyCoursesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) async {});
  }

  String collectionName = 'UDEMY COURSES';

  handleLoveClick() {
    bool guestUser = context.read<AuthenticationBLOC>().guestUser;

    if (guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBLOC>()
          .onLoveIconClick(collectionName, widget.data.timestamp!);
    }
  }

  handleBookmarkClick() {
    bool guestUser = context.read<AuthenticationBLOC>().guestUser;

    if (guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBLOC>()
          .onBookmarkIconClick(collectionName, widget.data.timestamp!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBLOC sb = context.watch<AuthenticationBLOC>();
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Hero(
                  tag: widget.tag!,
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.5,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Carousel(
                          dotBgColor: Colors.transparent,
                          showIndicator: true,
                          dotSize: 5,
                          dotSpacing: 15,
                          boxFit: BoxFit.fill,
                          images: [
                            CustomCacheImage(imageUrl: widget.data.image_01!),
                            CustomCacheImage(imageUrl: widget.data.image_02!),
                            CustomCacheImage(imageUrl: widget.data.image_03!),
                          ]),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 15,
                  child: SafeArea(
                    child: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.9),
                      child: IconButton(
                        icon: const Icon(
                          LineIcons.arrowLeft,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Icon(
                        LineIcons.checkCircle,
                        size: 20,
                        color: Colors.green,
                      ),
                      Expanded(
                          child: Text(
                        "  ${widget.data.courseCategory!}",
                        style: const TextStyle(
                          fontSize: 13,
                          /*color: Colors.grey[600],*/
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      IconButton(
                          icon: LoveCard(
                              collectionName: collectionName,
                              uid: sb.uid,
                              timestamp: widget.data.timestamp!),
                          onPressed: () {
                            handleLoveClick();
                          }),
                      IconButton(
                          icon: BookmarkCard(
                              collectionName: collectionName,
                              uid: sb.uid,
                              timestamp: widget.data.timestamp!),
                          onPressed: () {
                            handleBookmarkClick();
                          }),
                    ],
                  ),
                  Text(widget.data.courseName!.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          /*color: Colors.grey[800]*/)),
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    height: 3,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LoveCount(
                          collectionName: collectionName,
                          timestamp: widget.data.timestamp!),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Html(
                    data: '''${widget.data.courseDescription}''',
                    /*defaultTextStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[800]),*/
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: MaterialButton(
                      height: 50,
                      minWidth: MediaQuery.of(context).size.width/2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () async
                      {
                        if (await canLaunch(widget.data.courseDriveLink!))
                        {
                          await launch(widget.data.courseDriveLink!);
                        }
                        else
                        {
                          throw 'COULD NOT LAUNCH URL';
                        }
                      },
                      color: const Color(0xFFF7CA18),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "DOWNLOAD COURSE",
                          style: TextStyle(
                            fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey[800]
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const OtherUdemyCourses(),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
