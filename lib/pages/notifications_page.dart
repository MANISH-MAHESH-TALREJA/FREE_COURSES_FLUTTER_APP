import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/bloc/notification_bloc.dart';
import 'package:blog/models/notification_model.dart';
import 'package:blog/utility/general_utility_functions.dart';
import '../bloc/theme_bloc.dart';
import 'notification_details_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  ScrollController? controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<NotificationBLOC>().onRefresh(mounted);
    });
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<NotificationBLOC>();

    if (!db.isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
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
        title: Text('NOTIFICATIONS', style: TextStyle(color: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.black,)),
        actions: [
          IconButton(
            icon: const Icon(
              Feather.rotate_cw,
              size: 22,
            ),
            onPressed: () => context.read<NotificationBLOC>().onReload(mounted),
          )
        ],
      ),
      body: RefreshIndicator(
        child: ListView.separated(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: nb.data.length + 1,
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          itemBuilder: (_, int index) {
            if (index < nb.data.length) {
              return _ListItem(d: nb.data[index]);
            }
            return Center(
              child: Opacity(
                opacity: nb.isLoading ? 1.0 : 0.0,
                child: const SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: CircularProgressIndicator()),
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

  const _ListItem({required this.d});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          child: Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                    radius: 30,
                  backgroundColor: Colors.transparent,
                    child: Image.asset("assets/images/notify.gif"),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(CupertinoIcons.time_solid,
                                size: 16, color: Colors.green),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              d.createdAt.toString().toUpperCase(),
                              style:
                                  const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
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
