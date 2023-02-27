import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class LoadingPopularCoursesCard extends StatelessWidget {
  const LoadingPopularCoursesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
        child: Container(
            margin: const EdgeInsets.only(left: 0, right: 10, top: 5, bottom: 5),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.35,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10))));
  }
}

class LoadingFeaturedCoursesCard extends StatelessWidget {
  const LoadingFeaturedCoursesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
        child: Container(
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10))));
  }
}

class LoadingCard extends StatelessWidget {
  final double height;

  const LoadingCard({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: SkeletonAnimation(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(3)),
          height: height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
