import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:blog/models/udemy_courses_model.dart';
import 'package:blog/models/video_courses_model.dart';
import 'package:blog/pages/udemy_courses_detail_page.dart';
import 'package:blog/pages/video_courses_details_page.dart';
import 'package:blog/utility/general_utility_functions.dart';
import 'package:blog/widgets/custom_cache_image.dart';

class ListCard extends StatelessWidget {
  final UdemyCoursesModel d;
  final String? tag;
  final Color color;

  const ListCard(
      {Key? key, required this.d, required this.tag, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomRight,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 15, bottom: 0),
            child: Stack(
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.only(top: 15, left: 25, right: 10, bottom: 10),
                  alignment: Alignment.topLeft,
                  height: 120,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 115),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            d.courseName!.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Feather.check_circle,
                                size: 12,
                                color: Colors.green,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                child: Text(
                                  " ${d.courseCategory!}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      /*color: Colors.grey[700]*/),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 20),
                            height: 2,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    LineIcons.heart,
                                    size: 18,
                                    color: Colors.orangeAccent,
                                  ),
                                  Text(
                                    "  ${d.loves}",
                                    style: const TextStyle(
                                        fontSize: 13, /*color: Colors.grey[600]*/),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    LineIcons.calendar,
                                    size: 18,
                                    color: Colors.orangeAccent,
                                  ),
                                  Text(
                                    " ${d.date}",
                                    style: const TextStyle(
                                        fontSize: 13, /*color: Colors.grey[600]*/),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 30,
              left: 5,
              child: Hero(
                tag: tag!,
                child: SizedBox(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CustomCacheImage(imageUrl: d.image_01!))),
              ))
        ],
      ),
      onTap: () =>
          nextScreen(context, UdemyCoursesDetailPage(data: d, tag: tag)),
    );
  }
}

class ListCard2 extends StatelessWidget {
  final VideoCoursesModel d;
  final String? tag;
  final Color color;

  const ListCard2(
      {Key? key, required this.d, required this.tag, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomRight,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 15, bottom: 0),
            child: Stack(
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.only(top: 15, left: 25, right: 10, bottom: 10),
                  alignment: Alignment.topLeft,
                  height: 120,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 115),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            d.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Feather.check_circle,
                                size: 12,
                                color: Colors.green,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                child: Text(
                                  " ${d.channel!}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      /*color: Colors.grey[700]*/),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 20),
                            height: 2,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    LineIcons.heart,
                                    size: 18,
                                    color: Colors.orangeAccent,
                                  ),
                                  Text(
                                    "  ${d.loves}",
                                    style: const TextStyle(
                                        fontSize: 13, /*color: Colors.grey[600]*/),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    LineIcons.calendar,
                                    size: 18,
                                    color: Colors.orangeAccent,
                                  ),
                                  Text(
                                    " ${d.date}",
                                    style: const TextStyle(
                                        fontSize: 13, /*color: Colors.grey[600]*/),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 30,
              left: 5,
              child: Hero(
                tag: tag!,
                child: SizedBox(
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CustomCacheImage(imageUrl: d.thumbnail!))),
              ))
        ],
      ),
      onTap: () =>
          nextScreen(context, VideoCoursesDetailsPage(blogData: d, tag: tag)),
    );
  }
}
