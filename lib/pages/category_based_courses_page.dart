import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:blog/models/udemy_courses_model.dart';
import 'package:blog/pages/udemy_courses_detail_page.dart';
import 'package:blog/utility/general_utility_functions.dart';
import 'package:blog/widgets/custom_cache_image.dart';
import 'package:blog/utility/loading_cards.dart';
import 'empty_page.dart';

class CategoryBasedCoursesPage extends StatefulWidget {
  final String stateName;
  final Color color;

  CategoryBasedCoursesPage({Key? key, required this.stateName, required this.color})
      : super(key: key);

  @override
  _CategoryBasedCoursesPageState createState() => _CategoryBasedCoursesPageState();
}

class _CategoryBasedCoursesPageState extends State<CategoryBasedCoursesPage> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final String collectionName = 'UDEMY COURSES';
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  bool? _isLoading;
  List<DocumentSnapshot> _snap = [];
  List<UdemyCoursesModel> _data = [];
  bool? _hasData;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

  onRefresh() {
    setState(() {
      _snap.clear();
      _data.clear();
      _isLoading = true;
      _lastVisible = null;
    });
    _getData();
  }

  Future<Null> _getData() async {
    setState(() => _hasData = true);
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await fireStore
          .collection(collectionName)
          .where('COURSE CATEGORY', isEqualTo: widget.stateName)
          .get();
    else
      data = await fireStore
          .collection(collectionName)
          .where('COURSE CATEGORY', isEqualTo: widget.stateName)
          .startAfter([_lastVisible!['LOVES']])
          .get();

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => UdemyCoursesModel.fromFirestore(e)).toList();
        });
      }
    } else {
      if (_lastVisible == null) {
        setState(() {
          _isLoading = false;
          _hasData = false;
          print('NO ITEMS');
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasData = true;
          print('NO MORE ITEMS');
        });
      }
    }
    return null;
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading!) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
              backgroundColor: widget.color,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                background: Container(
                  color: widget.color,
                  height: 120,
                  width: double.infinity,
                ),
                title: Text(
                  widget.stateName.toUpperCase(),
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                titlePadding: EdgeInsets.only(left: 20, bottom: 15),
              ),
            ),
            _hasData == false
                ? SliverFillRemaining(
                    child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.30,
                      ),
                      EmptyPage(
                          icon: Feather.clipboard,
                          message: 'NO COURSE FOUND',
                          message1: ''),
                    ],
                  ))
                : SliverPadding(
                    padding: EdgeInsets.all(15),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < _data.length) {
                            return _ListItem(
                              d: _data[index],
                              tag: '${_data[index].timestamp}$index',
                            );
                          }
                          return Opacity(
                            opacity: _isLoading! ? 1.0 : 0.0,
                            child: _lastVisible == null
                                ? Column(
                                    children: [
                                      LoadingCard(
                                        height: 180,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  )
                                : Center(
                                    child: SizedBox(
                                        width: 32.0,
                                        height: 32.0,
                                        child:
                                            new CupertinoActivityIndicator()),
                                  ),
                          );
                        },
                        childCount: _data.length == 0 ? 5 : _data.length + 1,
                      ),
                    ),
                  )
          ],
        ),
        onRefresh: () async => onRefresh(),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final UdemyCoursesModel d;
  final String? tag;

  const _ListItem({Key? key, required this.d, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Container(
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Hero(
                        tag: tag!,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: CustomCacheImage(imageUrl: d.image_01!)),
                      )),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.courseName!.toUpperCase(),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Feather.check_circle,
                              size: 16,
                              color: Colors.indigo,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Expanded(
                              child: Text(
                                "  "+d.courseCategory!,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              CupertinoIcons.time,
                              size: 16,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "  "+d.date!,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Icon(
                              LineIcons.heart,
                              size: 16,
                              color: Colors.orange,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "  "+d.loves.toString(),
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
      onTap: () => nextScreen(context, UdemyCoursesDetailPage(data: d, tag: tag)),
    );
  }
}
