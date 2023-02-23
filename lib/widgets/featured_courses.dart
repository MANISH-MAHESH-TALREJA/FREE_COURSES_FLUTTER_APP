import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/bloc/featured_courses_bloc.dart';
import 'package:blog/models/udemy_courses_model.dart';
import 'package:blog/pages/udemy_courses_detail_page.dart';
import 'package:blog/utility/general_utility_functions.dart';
import 'package:blog/widgets/custom_cache_image.dart';
import 'package:blog/utility/loading_cards.dart';

class FeaturedCourses extends StatefulWidget
{
  FeaturedCourses({Key? key}) : super(key: key);

  _FeaturedCoursesState createState() => _FeaturedCoursesState();
}

class _FeaturedCoursesState extends State<FeaturedCourses>
{
  int listIndex = 2;

  @override
  Widget build(BuildContext context)
  {
    final fb = context.watch<FeaturedCoursesBLOC>();
    double w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 260,
          width: w,
          child: PageView.builder(
            controller: PageController(initialPage: 2),
            scrollDirection: Axis.horizontal,
            itemCount: fb.data.isEmpty ? 1 : fb.data.length,
            onPageChanged: (index) {
              setState(() {
                listIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              if (fb.data.isEmpty) return LoadingFeaturedCoursesCard();
              return _FeaturedItemList(d: fb.data[index]);
            },
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Center(
          child: DotsIndicator(
            dotsCount: 5,
            position: listIndex.toDouble(),
            decorator: DotsDecorator(
              color: Colors.black26,
              activeColor: Colors.black,
              spacing: EdgeInsets.only(left: 6),
              size: const Size.square(5.0),
              activeSize: const Size(20.0, 4.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
          ),
        )
      ],
    );
  }
}

class _FeaturedItemList extends StatelessWidget
{
  final UdemyCoursesModel d;
  const _FeaturedItemList({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    double w = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: w,
      child: InkWell(
        child: Stack(
          children: <Widget>[
            Hero(
              tag: 'FEATURED ${d.timestamp}',
              child: Container(
                  height: 220,
                  width: w,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CustomCacheImage(imageUrl: d.image_01!))),
            ),
            Positioned(
              height: 120,
              width: w * 0.70,
              left: w * 0.11,
              bottom: 10,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey[200]!,
                          offset: Offset(0, 2),
                          blurRadius: 2)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Center(
                          child: Text(
                            d.courseName!.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[300],
                        height: 20,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  LineIcons.heart,
                                  size: 18,
                                  color: Colors.orange,
                                ),
                                Text(
                                  "  " + d.loves.toString() + " LIKES",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700]),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  LineIcons.calendar,
                                  size: 18,
                                  color: Colors.orange,
                                ),
                                Text(
                                  //"  "+d.commentsCount.toString()+" COMMENTS",
                                  "  " + d.date!,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700]),
                                ),
                              ],
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          nextScreen(
              context, UdemyCoursesDetailPage(data: d, tag: 'FEATURED ${d.timestamp}'));
        },
      ),
    );
  }
}
