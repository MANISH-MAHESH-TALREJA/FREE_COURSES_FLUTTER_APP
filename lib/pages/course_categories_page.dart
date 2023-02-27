import 'package:blog/utility/general_utility_classes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:blog/bloc/technical_blog_bloc.dart';
import 'package:blog/bloc/course_category_bloc.dart';
import 'package:blog/models/course_categories_model.dart';
import 'package:blog/pages/category_based_courses_page.dart';

import 'package:blog/utility/general_utility_functions.dart';
import 'package:blog/widgets/custom_cache_image.dart';
import 'package:blog/utility/loading_cards.dart';

import '../bloc/theme_bloc.dart';
import 'empty_page.dart';

class CourseCategoriesPage extends StatefulWidget {
  const CourseCategoriesPage({Key? key}) : super(key: key);

  @override
  CourseCategoriesPageState createState() => CourseCategoriesPageState();
}

class CourseCategoriesPageState extends State<CourseCategoriesPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController? controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<CourseCategoryBLOC>().getData(mounted);
    });
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<TechnicalBlogBLOC>();

    if (!db.isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
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
        title: Text('COURSES CATEGORIES', style: TextStyle(color: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.black,)),
        elevation: 0,
      ),
      body: RefreshIndicator(
        child: sb.hasData == false
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  const EmptyPage(
                      icon: Feather.clipboard,
                      message: 'NO CATEGORIES FOUND',
                      message1: 'TRY AGAIN'),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(15),
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: sb.data.isNotEmpty ? sb.data.length + 1 : 8,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(
                  height: 10,
                ),
                itemBuilder: (_, int index) {
                  if (index < sb.data.length) {
                    return _ItemList(d: sb.data[index]);
                  }
                  return Opacity(
                    opacity: sb.isLoading ? 1.0 : 0.0,
                    child: sb.lastVisible == null
                        ? const LoadingCard(height: 140)
                        : const Center(
                            child: SizedBox(
                                width: 32.0,
                                height: 32.0,
                                child: CupertinoActivityIndicator()),
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

  const _ItemList({Key? key, required this.d}) : super(key: key);

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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CustomCacheImage(
                        imageUrl: d.categoryImage!,
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
                        d.name!.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
            stateName: d.name!,
            color: (ColorList().randomColors..shuffle()).first,
          )),
    );
  }
}
