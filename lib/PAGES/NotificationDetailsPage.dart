import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog/MODELS/NotificationModel.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationDetailsPage extends StatelessWidget {
  final NotificationModel data;

  const NotificationDetailsPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('NOTIFICATION DETAILS'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 30, bottom: 15, left: 20, right: 20),
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
                Icon(CupertinoIcons.time_solid, size: 20, color: Colors.green),
                SizedBox(
                  width: 3,
                ),
                Text(
                  data.createdAt.toString().toUpperCase(),
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(data.title!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 20),
              height: 3,
              width: 300,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            HtmlWidget(
              data.description!,
              textStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              onTapUrl: (url) async {
                await launch(url);
                return true;
              },
            ),
          ],
        ),
      ),
    );
  }
}
