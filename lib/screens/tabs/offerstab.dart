import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loan_bazaar/firebase/dbtools.dart';
import 'package:loan_bazaar/utils/FBAdUtils.dart';
import 'package:loan_bazaar/widgets/offerCategory.dart';

class OffersTab extends StatelessWidget {
  const OffersTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: DBtools().offersStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }
            List<QueryDocumentSnapshot> li = snapshot.data.docs;
            return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        li[index].id,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      OfferCategory(li: li[index]),
                      SizedBox(
                        height: 20,
                      ),
                      FBAdUtils.banner(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              },
              itemCount: li.length,
            );
          }),
    );
  }
}
