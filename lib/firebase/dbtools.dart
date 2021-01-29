import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:loan_bazaar/models/creditCards.dart';
import 'package:loan_bazaar/models/instantLoan.dart';
import 'package:loan_bazaar/models/banner.dart';

class DBtools {
  //loans
  final CollectionReference loans =
      FirebaseFirestore.instance.collection('instantLoans');
  Stream<List<InstantLoan>> queryloanStream({@required String name}) {
    Query q = loans
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: name + 'z');
    //  }
    return q?.snapshots()?.map(
          (event) => event?.docs
              ?.toList()
              ?.map((e) => InstantLoan.fromSnapShot(e))
              ?.toList(),
        );
  }

  Stream<List<InstantLoan>> loanStream() => loans?.snapshots()?.map((event) =>
      event?.docs?.toList()?.map((e) => InstantLoan.fromSnapShot(e))?.toList());
  //single loan
  Future<InstantLoan> singleLoan(String id) async {
    var t = await loans.doc(id).get();
    if (!t.exists) {
      throw 'No data found';
    }
    return InstantLoan.fromSnapShot(t);
  }

  //credit cards
  CollectionReference cardsreference =
      FirebaseFirestore.instance.collection('creditCards');
  Stream<List<CreditCard>> cardstream() =>
      cardsreference?.snapshots()?.map((event) => event?.docs
          ?.toList()
          ?.map((e) => CreditCard.fromSnapShot(e))
          ?.toList());
  //single card
  Future<CreditCard> singleCard(id) async {
    var t = await cardsreference.doc(id).get();
    if (!t.exists) {
      throw 'No data found';
    }
    return CreditCard.fromSnapShot(t);
  }

  //banners
  CollectionReference bannersreference =
      FirebaseFirestore.instance.collection('banners');
  Stream<List<Banner>> bannerstream() =>
      bannersreference?.snapshots()?.map((event) =>
          event?.docs?.toList()?.map((e) => Banner.fromSnapshot(e))?.toList());
  //offers
  CollectionReference offersreference =
      FirebaseFirestore.instance.collection('offers');
  Stream<QuerySnapshot> offersStream() => offersreference.snapshots();
}
