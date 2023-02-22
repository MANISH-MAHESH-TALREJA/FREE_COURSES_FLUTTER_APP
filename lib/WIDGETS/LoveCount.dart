import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoveCount extends StatelessWidget
{
  final String collectionName;
  final String timestamp;
  const LoveCount({Key key, @required this.collectionName, @required this.timestamp}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.favorite,
              color: Colors.red,
              size: 23,
            ),
            SizedBox(
              width: 5,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection(collectionName).doc(timestamp).snapshots(),
              builder: (context, AsyncSnapshot snap)
              {
                if (!snap.hasData)
                  return Text(
                    "  "+0.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  );
                return Text(
                  snap.data['LOVES'].toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                );
              },
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'PEOPLE LIKE THIS COURSE',
              maxLines: 1,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
