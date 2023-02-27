import 'package:flutter/material.dart';

class LoveIcon
{
  Icon normal = const Icon(Icons.favorite_border, color: Colors.orange,);
  Icon bold = const Icon(Icons.favorite, color: Colors.orange,);
}

class BookmarkIcon
{
  Icon normal = const Icon(Icons.bookmark_border, color: Colors.orange,);
  Icon bold = const Icon(Icons.bookmark, color: Colors.orange,);
}

class LockIcon
{
  Icon lock = const Icon(Icons.lock);
  Icon lockOn = const Icon(Icons.lock);
  Icon lockOff = const Icon(Icons.lock_open);
}

class ColorList
{
  List randomColors =
  [
    Colors.orange[200],
    Colors.blue[200],
    Colors.red[200],
    Colors.pink[200],
    Colors.purple[200],
    Colors.blueGrey[400]
  ];
}