import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/BLOC/NotificationBLOC.dart';
import 'package:blog/MODELS/NotificationModel.dart';
import 'package:blog/UTILITY/GeneralUtilityFunctions.dart';
import 'NotificationDetailsPage.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({Key key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  ScrollController controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      context.read<NotificationBLOC>().onRefresh(mounted);
    });
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<NotificationBLOC>();

    if (!db.isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        context.read<NotificationBLOC>().setLoading(true);
        context.read<NotificationBLOC>().getData(mounted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final nb = context.watch<NotificationBLOC>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('NOTIFICATIONS'),
        actions: [
          IconButton(
            icon: Icon(
              Feather.rotate_cw,
              size: 22,
            ),
            onPressed: () => context.read<NotificationBLOC>().onReload(mounted),
          )
        ],
      ),
      body: RefreshIndicator(
        child: ListView.separated(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          controller: controller,
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: nb.data.length + 1,
          separatorBuilder: (context, index) => SizedBox(
            height: 10,
          ),
          itemBuilder: (_, int index) {
            if (index < nb.data.length) {
              return _ListItem(d: nb.data[index]);
            }
            return Center(
              child: new Opacity(
                opacity: nb.isLoading ? 1.0 : 0.0,
                child: new SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: new CircularProgressIndicator()),
              ),
            );
          },
        ),
        onRefresh: () async {
          context.read<NotificationBLOC>().onRefresh(mounted);
        },
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final NotificationModel d;

  const _ListItem({Key key, @required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                    child: Image.asset("assets/images/notify.gif"),
                  radius: 30,
                  backgroundColor: Colors.transparent,
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(CupertinoIcons.time_solid,
                                size: 16, color: Colors.green),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              d.createdAt.toString().toUpperCase(),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () => nextScreen(context, NotificationDetailsPage(data: d)),
    );
  }
}
