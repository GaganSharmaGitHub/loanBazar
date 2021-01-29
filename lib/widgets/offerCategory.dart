import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/firebase/dbtools.dart';

class OfferCategory extends StatelessWidget {
  const OfferCategory({
    Key key,
    @required this.li,
  }) : super(key: key);

  final QueryDocumentSnapshot li;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: DBtools()
            .offersreference
            .doc(li.id)
            .collection('offers')
            .snapshots(),
        builder: (context, snap) {
          if (snap.hasError || !snap.hasData || snap.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          return SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: snap.data.docs.map((e) {
                Map data = e.data();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${data['title']}'),
                      Expanded(
                          child: InkWell(
                              onTap: () => Navigator.of(context).pushNamed(
                                  Routes.singleOffer,
                                  arguments: data),
                              child: Image.network(data['image']))),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        });
  }
}
