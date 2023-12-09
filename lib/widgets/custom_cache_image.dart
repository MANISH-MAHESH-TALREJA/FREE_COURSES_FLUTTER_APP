import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCacheImage extends StatelessWidget
{
  final String imageUrl;
  const CustomCacheImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      height: MediaQuery.of(context).size.height,
      placeholder: (context, url) => Container(color: Colors.grey[300]),
      errorWidget: (context, url, error) => Center(
        child: Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        ),
      ),
    );
  }
}
