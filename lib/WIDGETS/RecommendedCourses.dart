import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/BLOC/RecommendedCoursesBLOC.dart';
import 'package:blog/MODELS/UdemyCoursesModel.dart';
import 'package:blog/PAGES/MoreCoursesPage.dart';
import 'package:blog/PAGES/UdemyCoursesDetailPage.dart';
import 'package:blog/UTILITY/GeneralUtilityFunctions.dart';
import 'package:blog/WIDGETS/CustomCacheImage.dart';

class RecommendedCourses extends StatelessWidget
{
  RecommendedCourses({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context)
  {
    final RecommendedCoursesBLOC rpb = Provider.of<RecommendedCoursesBLOC>(context);
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: 15,
            top: 10,
            right: 15,
          ),
          child: Row(
            children: <Widget>[
              Text(
                'RECOMMENDED COURSES',
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
                      title: 'RECOMMENDED',
                      color: Colors.green[300]!,
                    )),
              )
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: ListView.separated(
            padding: EdgeInsets.only(top: 10, bottom: 30, left: 15, right: 15),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: rpb.data.length,
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (BuildContext context, int index)
            {
              if (rpb.data.isEmpty) return Container();
              return _ListItem(d: rpb.data[index]);
            },
          ),
        )
      ],
    );
  }
}

class _ListItem extends StatelessWidget
{
  final UdemyCoursesModel d;
  const _ListItem({Key? key, required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return InkWell(
      child: Stack(
        children: <Widget>[
          Hero(
            tag: 'RECOMMENDED ${d.timestamp}',
            child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CustomCacheImage(imageUrl: d.image_01!))),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(top: 10, right: 15),
              child: TextButton.icon(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25))
                        )
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.grey[600]!.withOpacity(0.5))
                ),
                icon: Icon(
                  LineIcons.heart,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  d.loves.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                onPressed: () {},
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.grey[900]!.withOpacity(0.6),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    d.courseName!.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Feather.check_circle, size: 15, color: Colors.green),
                      Text(
                        "  "+d.courseCategory!,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      onTap: () => nextScreen(
          context, UdemyCoursesDetailPage(data: d, tag: 'RECOMMENDED ${d.timestamp}')),
    );
  }
}
