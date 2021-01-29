import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan_bazaar/constants/endpoints.dart';
import 'package:share/share.dart';

class CreditCard {
  String name, link, logo, bank, id;
  List benefits;
  Map documents, fees;
  Map toMap() {
    return {
      "documents": documents,
      "benefits": benefits,
      "fees": fees,
      "link": link,
      "logo": logo,
      "name": name,
      "bank": bank
    };
  }

  static CreditCard fromSnapShot(QueryDocumentSnapshot e) {
    Map data = e.data();
    data['id'] = e.id;

    return CreditCard.fromMap(data);
  }

  share() {
    //   Uri uri = Uri.https();
    Uri uri = Uri.http(EPS.url, EPS.creditcard, {'id': '$id'});
    Share.share('look I found a credit card on Loan Bazaar $uri');
  }

  static CreditCard fromMap(Map p) {
    if (!(p['benefits'] is List)) {
      p['benefits'] = [];
    }
    return CreditCard(
        documents: p['documents'],
        fees: p['fees'],
        link: p['link'],
        logo: p['logo'],
        name: p['name'],
        bank: p['bank'],
        benefits: p['benefits'],
        id: p['id']);
  }

  CreditCard({
    this.documents,
    this.fees,
    this.link,
    this.logo,
    this.id,
    this.bank,
    this.benefits,
    this.name,
  });
}
