import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoveCount extends StatelessWidget
{
  final String collectionName;
  final String timestamp;
  const LoveCount({super.key, required this.collectionName, required this.timestamp});

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
            const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 23,
            ),
            const SizedBox(
              width: 5,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection(collectionName).doc(timestamp).snapshots(),
              builder: (context, AsyncSnapshot snap)
              {
                if (!snap.hasData) {
                  return const Text(
                    "  ${0}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        /*color: Colors.black*/),
                  );
                }
                return Text(
                  snap.data['LOVES'].toString(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      /*color: Colors.black*/),
                );
              },
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'People Like This Course',
              maxLines: 1,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, /*color: Colors.black*/),
            )
          ],
        ),
      ),
    );
  }
}
