import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog/models/notification_model.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/theme_bloc.dart';

class NotificationDetailsPage extends StatelessWidget {
  final NotificationModel data;

  const NotificationDetailsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('NOTIFICATION DETAILS', style: TextStyle(color: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.black,)),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 30, bottom: 15, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Image.asset(
                "assets/images/courses_01.gif",
                height: MediaQuery.of(context).size.height * 0.25,
              )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(CupertinoIcons.time_solid, size: 20, color: Colors.green),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  data.createdAt.toString().toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(data.title!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 20),
              height: 3,
              width: 300,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            HtmlWidget(
              data.description!,
              textStyle: const TextStyle(
                fontSize: 16,
                /*color: Colors.grey[600],*/
              ),
              onTapUrl: (url) async {
                await launchUrl(Uri.parse(url));
                return true;
              },
            ),
          ],
        ),
      ),
    );
  }
}
