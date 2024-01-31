import 'package:blog/utility/general_utility_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:share/share.dart';
import 'package:blog/bloc/bookmark_bloc.dart';
import 'package:blog/bloc/authentication_bloc.dart';
import 'package:blog/models/technical_blog_model.dart';
import 'package:blog/widgets/custom_cache_image.dart';
import 'package:blog/widgets/love_count.dart';
import 'package:blog/widgets/love_card.dart';
import 'package:blog/widgets/other_video_courses.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class TechnicalBlogDetailsPage extends StatefulWidget {
  final TechnicalBlogModel blogData;
  final String? tag;

  const TechnicalBlogDetailsPage({super.key, required this.blogData, required this.tag});

  @override
  TechnicalBlogDetailsPageState createState() => TechnicalBlogDetailsPageState();
}

class TechnicalBlogDetailsPageState extends State<TechnicalBlogDetailsPage> {
  final String collectionName = 'TECHNICAL BLOGS';

  handleLoveClick() {
    bool guestUser = context.read<AuthenticationBLOC>().guestUser;

    if (guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBLOC>()
          .onLoveIconClick(collectionName, widget.blogData.timestamp!);
    }
  }

  handleBookmarkClick() {
    bool guestUser = context.read<AuthenticationBLOC>().guestUser;

    if (guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBLOC>()
          .onBookmarkIconClick(collectionName, widget.blogData.timestamp!);
    }
  }

  handleSource(link) async {
    if (await canLaunchUrl(Uri.parse(link))) {
      launchUrl(Uri.parse(link));
    }
  }

  handleShare() {
    Share.share(
        '${widget.blogData.title}, TO READ MORE, INSTALL ${Constants().appName} APP. https://play.google.com/store/apps/details?id=net.manish.blog');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBLOC sb = context.watch<AuthenticationBLOC>();
    final TechnicalBlogModel d = widget.blogData;
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            /*color: Colors.grey[200],*/
                            borderRadius: BorderRadius.circular(5)),
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const Text(
                        "TECHNICAL BLOGS",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.indigo),
                      ),
                      Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              /*color: Colors.grey[200],*/
                              borderRadius: BorderRadius.circular(5)),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(
                              Icons.share,
                              size: 22,

                            ),
                            onPressed: () {
                              handleShare();
                            },
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Icon(
                            CupertinoIcons.time,
                            size: 18,
                            color: Colors.green,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            d.date!,
                            style: const TextStyle(
                                fontSize: 13, /*color: Colors.grey[700],*/ fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        d.title!,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            /*color: Colors.grey[800]*/),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        height: 3,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton.icon(
                            //color: Colors.grey[200],
                            //padding: EdgeInsets.all(2),
                            onPressed: () async
                            {
                              var url = d.blogLink;
                              if(await canLaunchUrl(Uri.parse(url!)))
                              {
                                await launchUrl(Uri.parse(url));
                              }
                              else
                              {
                                throw 'COULD NOT LAUNCH';
                              }
                            },
                            style:  ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.purpleAccent)
                            ),
                            icon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal:5.0),
                              child: Icon(Feather.book_open,
                                  size: 20, color: Colors.white),
                            ),
                            label: const Padding(
                              padding: EdgeInsets.only(right:8.0),
                              child: Text(
                                "READ FULL BLOG",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: LoveCard(
                                  collectionName: collectionName,
                                  uid: sb.uid,
                                  timestamp: d.timestamp!),
                              onPressed: () {
                                handleLoveClick();
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Hero(
                  tag: widget.tag!,
                  child: SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child:
                              CustomCacheImage(imageUrl: d.thumbnail!))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      LoveCount(
                          collectionName: collectionName,
                          timestamp: d.timestamp!),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Html(
                    /*defaultTextStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[800]),*/
                    data: '''  ${d.description}   '''),
                const SizedBox(
                  height: 20,
                ),
                const OtherVideoCourses(),
                const SizedBox(
                  height: 10,
                ),
              ]),
        ),
      ),
    );
  }
}
