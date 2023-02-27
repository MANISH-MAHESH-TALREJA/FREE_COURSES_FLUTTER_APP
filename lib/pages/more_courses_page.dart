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

class MoreCoursesPage extends StatefulWidget {
  final String title;
  final Color color;

  const MoreCoursesPage({Key? key, required this.title, required this.color})
      : super(key: key);

  @override
  MoreCoursesPageState createState() => MoreCoursesPageState();
}

class MoreCoursesPageState extends State<MoreCoursesPage> {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final String collectionName = 'UDEMY COURSES';
  ScrollController? controller;
  DocumentSnapshot? _lastVisible;
  bool? _isLoading;
  final List<DocumentSnapshot> _snap = [];
  List<UdemyCoursesModel> _data = [];
  bool? _descending;
  String? _orderBy;

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    if (widget.title == 'POPULAR') {
      _orderBy = 'LOVES';
      _descending = true;
    } else if (widget.title == 'RECOMMENDED') {
      _orderBy = 'LOVES';
      _descending = true;
    } else {
      _orderBy = 'TIMESTAMP';
      _descending = true;
    }
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

  Future<void> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null) {
      data = await fireStore
          .collection(collectionName)
          .orderBy(_orderBy!, descending: _descending!)
          .limit(5)
          .get();
    } else {
      data = await fireStore
          .collection(collectionName)
          .orderBy(_orderBy!, descending: _descending!)
          .startAfter([_lastVisible![_orderBy!]])
          .limit(5)
          .get();
    }

    if (data != null && data.docs.isNotEmpty) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => UdemyCoursesModel.fromFirestore(e)).toList();
        });
      }
    } else {
      setState(() => _isLoading = false);
    }
    return;
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
                  icon: const Icon(
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
                  widget.title,
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                titlePadding: const EdgeInsets.only(left: 20, bottom: 15),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(15),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < _data.length) {
                      return _ListItem(
                        d: _data[index],
                        tag: '${widget.title}$index',
                      );
                    }
                    return Opacity(
                      opacity: _isLoading! ? 1.0 : 0.0,
                      child: _lastVisible == null
                          ? Column(
                              children: const [
                                LoadingCard(
                                  height: 180,
                                ),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            )
                          : const Center(
                              child: SizedBox(
                                  width: 32.0,
                                  height: 32.0,
                                  child: CupertinoActivityIndicator()),
                            ),
                    );
                  },
                  childCount: _data.isEmpty ? 5 : _data.length + 1,
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
  final tag;

  const _ListItem({Key? key, required this.d, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:5.0),
      child: InkWell(
        child: Card(
          child: Container(
              decoration: BoxDecoration(
                  /*color: Colors.white,*/ borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Hero(
                        tag: tag,
                        child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            child: CustomCacheImage(imageUrl: d.image_01!)),
                      )),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.courseName!.toUpperCase(),
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Feather.check_circle,
                              size: 16,
                              color: Colors.indigo,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Expanded(
                              child: Text(
                                "  ${d.courseCategory!}",
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 13, /*color: Colors.grey[700],*/ fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              CupertinoIcons.time,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              "  ${d.date!}",
                              style: const TextStyle(
                                  fontSize: 13, /*color: Colors.grey[700],*/ fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            const Icon(
                              LineIcons.heart,
                              size: 16,
                              color: Colors.orange,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              "  ${d.loves}",
                              style: const TextStyle(
                                  fontSize: 13, /*color: Colors.grey[700],*/ fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
        onTap: () => nextScreen(context, UdemyCoursesDetailPage(data: d, tag: tag)),
      ),
    );
  }
}
