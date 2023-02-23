import 'dart:developer';

import 'package:blog/utility/general_utility_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:share/share.dart';
import 'package:blog/bloc/bookmark_bloc.dart';
import 'package:blog/bloc/authentication_bloc.dart';
import 'package:blog/models/video_courses_model.dart';
import 'package:blog/widgets/bookmark_card.dart';
import 'package:blog/widgets/love_count.dart';
import 'package:blog/widgets/love_card.dart';
import 'package:blog/widgets/other_video_courses.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants.dart';

class VideoCoursesDetailsPage extends StatefulWidget {
  final VideoCoursesModel blogData;
  final String? tag;

  VideoCoursesDetailsPage({Key? key, required this.blogData, required this.tag})
      : super(key: key);

  @override
  _BlogDetailsState createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<VideoCoursesDetailsPage> {
  final String collectionName = 'YOUTUBE VIDEO COURSES';
  handleLoveClick() {
    bool _guestUser = context.read<AuthenticationBLOC>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBLOC>()
          .onLoveIconClick(collectionName, widget.blogData.timestamp!);
    }
  }

  handleBookmarkClick() {
    bool _guestUser = context.read<AuthenticationBLOC>().guestUser;
    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context
          .read<BookmarkBLOC>()
          .onBookmarkIconClick(collectionName, widget.blogData.timestamp!);
    }
  }

  handleSource(link) async {
    if (await canLaunch(link)) {
      launch(link);
    }
  }

  handleShare() {
    Share.share(
        '${widget.blogData.title}, TO WATCH MORE VIDEOS, INSTALL ${Constants().appName} APP. https://play.google.com/store/apps/details?id=net.manish.blog');
  }

  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.blogData.videoID!,

      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        
        forceHD: false,
        enableCaption: true,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    final AuthenticationBLOC sb = context.watch<AuthenticationBLOC>();
    final VideoCoursesModel d = widget.blogData;
    YoutubePlayer player = YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
      topActions: <Widget>[
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            _controller!.metadata.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
            size: 25.0,
          ),
          onPressed: ()
          {
            log('Settings Tapped!');
          },
        ),
      ],
      onReady: ()
      {
      },
      onEnded: (data)
      {

      },
    );
    return YoutubePlayerBuilder(
      player: player,
      builder: (context, player)
      {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5)),
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Text(
                            "YOUTUBE COURSES",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.indigo),
                          ),
                          Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5)),
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                icon: Icon(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Feather.check_circle,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    " "+d.channel!,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Feather.clock,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    " "+d.date!,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            d.title!,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.grey[800]),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8, bottom: 8),
                            height: 3,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(40)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>
                            [

                              TextButton.icon(
                                //color: Colors.grey[200],
                                //padding: EdgeInsets.all(0),
                                onPressed: () async
                                {
                                  var url = "https://www.youtube.com/watch?v="+d.videoID!;
                                  if(await canLaunch(url))
                                  {
                                    await launch(url);
                                  }
                                  else
                                  {
                                    throw 'COULD NOT LAUNCH';
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.red)
                                ),
                                icon: Icon(Feather.youtube,
                                    size: 20, color: Colors.white),
                                label: Text(
                                  " OPEN YOUTUBE   ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                  icon: LoveCard(
                                      collectionName: collectionName,
                                      uid: sb.uid!,
                                      timestamp: d.timestamp!),
                                  onPressed: () {
                                    handleLoveClick();
                                  }),
                              IconButton(
                                  icon: BookmarkCard(
                                      collectionName: collectionName,
                                      uid: sb.uid!,
                                      timestamp: d.timestamp!),
                                  onPressed: () {
                                    handleBookmarkClick();
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Hero(
                      tag: widget.tag!,
                      child: Container(
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child:player,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          LoveCount(
                              collectionName: collectionName,
                              timestamp: d.timestamp!),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Html(
                        /*defaultTextStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[800]),*/
                        data: '''  ${d.description}   '''),
                    SizedBox(
                      height: 20,
                    ),
                    OtherVideoCourses(),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
