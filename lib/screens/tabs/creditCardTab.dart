import 'package:flutter/material.dart';
import 'package:loan_bazaar/firebase/dbtools.dart';
import 'package:loan_bazaar/utils/FBAdUtils.dart';
import 'package:loan_bazaar/models/creditCards.dart';
import 'package:loan_bazaar/widgets/creditCardCard.dart';

class CreditCardTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CreditCard>>(
        stream: DBtools().cardstream(),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
              body: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  CreditCardCard(
                    card: snapshot.data[index],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FBAdUtils.banner(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
            },
          ));
        });
  }
}
