import 'package:blog/pages/technical_blog_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'package:blog/bloc/technical_blog_bloc.dart';
import 'package:blog/models/technical_blog_model.dart';
import '../bloc/theme_bloc.dart';
import 'empty_page.dart';
import 'package:blog/utility/general_utility_functions.dart';
import 'package:blog/widgets/custom_cache_image.dart';
import 'package:blog/utility/loading_cards.dart';

class TechnicalBlogPage extends StatefulWidget {
  const TechnicalBlogPage({super.key});

  @override
  TechnicalBlogPageState createState() => TechnicalBlogPageState();
}

class TechnicalBlogPageState extends State<TechnicalBlogPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController? controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _orderBy = 'TIMESTAMP';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      controller = ScrollController()..addListener(_scrollListener);
      context.read<TechnicalBlogBLOC>().getData(mounted, _orderBy);
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
        context.read<TechnicalBlogBLOC>().setLoading(true);
        context.read<TechnicalBlogBLOC>().getData(mounted, _orderBy);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bb = context.watch<TechnicalBlogBLOC>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('TECHNICAL BLOGS', style: TextStyle(color: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.black,)),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FocusedMenuHolder(
            menuWidth: MediaQuery.of(context).size.width*0.50,
            blurSize: 0.0,
            menuItemExtent: 50,
            menuBoxDecoration: const BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(15.0))),
            duration: const Duration(milliseconds: 100),
            animateMenuItems: true,
            blurBackgroundColor: Colors.transparent,
            bottomOffsetHeight: 100,
            openWithTap: true,
            menuItems: <FocusedMenuItem>
            [
              FocusedMenuItem(title: const Text("MOST RECENTLY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,)),trailingIcon: const Icon(Icons.access_time, color: Colors.green,) ,onPressed: ()
              {
                _orderBy = 'TIMESTAMP';
                bb.afterPopSelection('RECENT', mounted, _orderBy);
              }),
              FocusedMenuItem(title: const Text("MOST POPULAR", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,),),trailingIcon: const Icon(Icons.favorite_border, color: Colors.pink,) ,onPressed: ()
              {
                _orderBy = 'LOVES';
                bb.afterPopSelection('POPULAR', mounted, _orderBy);
              }),
            ],
            onPressed: ()
            {

            },
            child: IconButton(onPressed: null, icon: Icon(CupertinoIcons.sort_down, color: context.watch<ThemeBloc>().darkTheme! == true ? Colors.white : Colors.black,)),
          ),
        ),
        actions: <Widget>
        [
          IconButton(
            icon: const Icon(
              Feather.rotate_cw,
              size: 22,
            ),
            onPressed: () {
              context.read<TechnicalBlogBLOC>().onRefresh(mounted, _orderBy);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        child: bb.hasData == false
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  const EmptyPage(
                      icon: Feather.clipboard,
                      message: 'NO COURSES FOUND',
                      message1: 'TRY AGAIN'),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(15),
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: bb.data.isNotEmpty ? bb.data.length + 1 : 5,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(
                  height: 15,
                ),
                itemBuilder: (_, int index) {
                  if (index < bb.data.length) {
                    return _ItemList(d: bb.data[index]);
                  }
                  return Opacity(
                    opacity: bb.isLoading ? 1.0 : 0.0,
                    child: bb.lastVisible == null
                        ? const LoadingCard(height: 250)
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
          context.read<TechnicalBlogBLOC>().onRefresh(mounted, _orderBy);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ItemList extends StatelessWidget {
  final TechnicalBlogModel d;

  const _ItemList({required this.d});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Card(
          child: Wrap(
            children: [
              Hero(
                tag: 'BLOG ${d.timestamp}',
                child: SizedBox(
                  height: 175,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CustomCacheImage(imageUrl: d.thumbnail!)),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                        HtmlUnescape()
                            .convert(parse(d.description).documentElement!.text),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            /*color: Colors.grey[700]*/)),
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
                          " ${d.date!}",
                          style: const TextStyle(fontSize: 13/*, color: Colors.grey*/, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.favorite,
                          size: 16,
                          color: Colors.orange,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          " ${d.loves}",
                          style: const TextStyle(fontSize: 12, /*color: Colors.grey,*/ fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () => nextScreen(
            context, TechnicalBlogDetailsPage(blogData: d, tag: 'BLOG ${d.timestamp}')));
  }
}
