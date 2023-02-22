import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:blog/BLOC/PopularCoursesBLOC.dart';
import 'package:blog/MODELS/UdemyCoursesModel.dart';
import 'package:provider/provider.dart';
import 'package:blog/PAGES/MoreCoursesPage.dart';
import 'package:blog/PAGES/UdemyCoursesDetailPage.dart';
import 'package:blog/UTILITY/GeneralUtilityFunctions.dart';
import 'package:blog/WIDGETS/CustomCacheImage.dart';
import 'package:blog/UTILITY/LoadingCards.dart';

class PopularCourses extends StatelessWidget
{
  PopularCourses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final pb = context.watch<PopularCoursesBLOC>();

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: 15,
            top: 10,
          ),
          child: Row(
            children: <Widget>[
              Text(
                'POPULAR COURSES',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800]),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => nextScreen(
                    context,
                    MoreCoursesPage(
                      title: 'POPULAR',
                      color: Colors.grey[800]!,
                    )),
              )
            ],
          ),
        ),
        Container(
          height: 220,
          //color: Colors.green,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 15, right: 15),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: pb.data.isEmpty ? 3 : pb.data.length,
            itemBuilder: (BuildContext context, int index) {
              if (pb.data.isEmpty) return LoadingPopularCoursesCard();
              return ItemList(
                d: pb.data[index],
              );
            },
          ),
        )
      ],
    );
  }
}

class ItemList extends StatelessWidget
{
  final UdemyCoursesModel d;

  const ItemList({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 0, right: 10, top: 5, bottom: 5),
        width: MediaQuery.of(context).size.width * 0.36,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Hero(
              tag: 'POPULAR ${d.timestamp}',
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomCacheImage(imageUrl: d.image_01!)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
                child: Text(
                  d.courseName!.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    right: 15,
                  ),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[600]!.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LineIcons.heart, size: 16, color: Colors.white),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          d.loves.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
      onTap: () => nextScreen(
          context, UdemyCoursesDetailPage(data: d, tag: 'POPULAR ${d.timestamp}')),
    );
  }
}
