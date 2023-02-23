import 'package:blog/pages/video_courses_details_page.dart';
import 'package:blog/pages/video_courses_search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:focused_menu/modals.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'package:blog/bloc/video_courses_bloc.dart';
import 'package:blog/models/video_courses_model.dart';
import 'empty_page.dart';
import 'package:blog/utility/general_utility_functions.dart';
import 'package:blog/utility/loading_cards.dart';

class VideoCoursesPage extends StatefulWidget {
  VideoCoursesPage({Key? key}) : super(key: key);

  @override
  _VideoCoursesPageState createState() => _VideoCoursesPageState();
}

class _VideoCoursesPageState extends State<VideoCoursesPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController? controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _orderBy = 'TIMESTAMP';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) async {
      controller = new ScrollController()..addListener(_scrollListener);
      await context.read<VideoCoursesBLOC>().getData(mounted, _orderBy);
    });
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<VideoCoursesBLOC>();

    if (!db.isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        context.read<VideoCoursesBLOC>().setLoading(true);
        context.read<VideoCoursesBLOC>().getData(mounted, _orderBy);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bb = context.watch<VideoCoursesBLOC>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Feather.search,
            size: 22,
          ),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCoursesSearchPage()));
          },
        ),
        title: Text('YOUTUBE COURSES', style: TextStyle(color: Colors.black),),
        elevation: 0,
        actions: <Widget>
        [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FocusedMenuHolder(
              menuWidth: MediaQuery.of(context).size.width*0.50,
              blurSize: 0.0,
              menuItemExtent: 50,
              menuBoxDecoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(15.0))),
              duration: Duration(milliseconds: 100),
              animateMenuItems: true,
              blurBackgroundColor: Colors.transparent,
              bottomOffsetHeight: 100,
              openWithTap: true,
              menuItems: <FocusedMenuItem>
              [
                FocusedMenuItem(title: Text("MOST RECENTLY", style: TextStyle(fontWeight: FontWeight.bold)),trailingIcon: Icon(Icons.access_time, color: Colors.green,) ,onPressed: ()
                {
                  _orderBy = 'TIMESTAMP';
                  bb.afterPopSelection('RECENT', mounted, _orderBy);
                }),
                FocusedMenuItem(title: Text("MOST POPULAR", style: TextStyle(fontWeight: FontWeight.bold),),trailingIcon: Icon(Icons.favorite_border, color: Colors.pink,) ,onPressed: ()
                {
                  _orderBy = 'LOVES';
                  bb.afterPopSelection('POPULAR', mounted, _orderBy);
                }),
              ],
              onPressed: ()
              {

              },
              child: IconButton(onPressed: null, icon: Icon(CupertinoIcons.sort_down, color: Colors.black,)),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        child: bb.hasData == false
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  EmptyPage(
                      icon: Feather.clipboard,
                      message: 'NO COURSES FOUND',
                      message1: 'TRY AGAIN'),
                ],
              )
            : ListView.separated(
                padding: EdgeInsets.all(15),
                controller: controller,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: bb.data.length != 0 ? bb.data.length + 1 : 5,
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 15,
                ),
                itemBuilder: (_, int index) {
                  if (index < bb.data.length) {
                    return VideoCourseItem(d: bb.data[index]);
                  }
                  return Opacity(
                    opacity: bb.isLoading ? 1.0 : 0.0,
                    child: bb.lastVisible == null
                        ? LoadingCard(height: 250)
                        : Center(
                            child: SizedBox(
                                width: 32.0,
                                height: 32.0,
                                child: new CupertinoActivityIndicator()),
                          ),
                  );
                },
              ),
        onRefresh: () async {
          context.read<VideoCoursesBLOC>().onRefresh(mounted, _orderBy);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class VideoCourseItem extends StatelessWidget {
  final VideoCoursesModel d;

  const VideoCourseItem({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Card(
          child: Container(
            child: Wrap(
              children: [
                Hero(
                  tag: 'VIDEOS ${d.timestamp}',
                  child: Container(
                    height: 175,
                    child: Stack(children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.network(
                                d.thumbnail!,
                                fit: BoxFit.fill,
                              )),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 100,
                            color: Colors.red.withOpacity(0.8),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                          HtmlUnescape()
                              .convert(parse(d.description).documentElement!.text),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[700])),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            CupertinoIcons.time,
                            size: 16,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            d.date!,
                            style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Icon(
                            Icons.favorite,
                            size: 16,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            d.loves.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () => nextScreen(
            context, VideoCoursesDetailsPage(blogData: d, tag: 'VIDEOS ${d.timestamp}')));
  }
}
