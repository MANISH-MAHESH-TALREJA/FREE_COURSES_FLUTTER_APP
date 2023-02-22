import 'package:blog/UTILITY/GeneralUtilityClasses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/BLOC/TechnicalBlogBLOC.dart';
import 'package:blog/BLOC/CourseCategoryBLOC.dart';
import 'package:blog/MODELS/CourseCategoriesModel.dart';
import 'package:blog/PAGES/CategoryBasedCoursesPage.dart';

import 'package:blog/UTILITY/GeneralUtilityFunctions.dart';
import 'package:blog/WIDGETS/CustomCacheImage.dart';
import 'package:blog/UTILITY/LoadingCards.dart';

import 'EmptyPage.dart';

class CourseCategoriesPage extends StatefulWidget {
  CourseCategoriesPage({Key key}) : super(key: key);

  @override
  _CourseCategoriesPageState createState() => _CourseCategoriesPageState();
}

class _CourseCategoriesPageState extends State<CourseCategoriesPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      context.read<CourseCategoryBLOC>().getData(mounted);
    });
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<TechnicalBlogBLOC>();

    if (!db.isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        context.read<CourseCategoryBLOC>().setLoading(true);
        context.read<CourseCategoryBLOC>().getData(mounted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sb = context.watch<CourseCategoryBLOC>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('COURSES CATEGORIES'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        child: sb.hasData == false
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  EmptyPage(
                      icon: Feather.clipboard,
                      message: 'NO CATEGORIES FOUND',
                      message1: 'TRY AGAIN'),
                ],
              )
            : ListView.separated(
                padding: EdgeInsets.all(15),
                controller: controller,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: sb.data.length != 0 ? sb.data.length + 1 : 8,
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 10,
                ),
                itemBuilder: (_, int index) {
                  if (index < sb.data.length) {
                    return _ItemList(d: sb.data[index]);
                  }
                  return Opacity(
                    opacity: sb.isLoading ? 1.0 : 0.0,
                    child: sb.lastVisible == null
                        ? LoadingCard(height: 140)
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
          context.read<CourseCategoryBLOC>().onRefresh(mounted);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ItemList extends StatelessWidget {
  final CourseCategoriesModel d;

  const _ItemList({Key key, @required this.d}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CustomCacheImage(
                        imageUrl: d.categoryImage,
                      )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        d.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
      onTap: () => nextScreen(
          context,
          CategoryBasedCoursesPage(
            stateName: d.name,
            color: (ColorList().randomColors..shuffle()).first,
          )),
    );
  }
}
