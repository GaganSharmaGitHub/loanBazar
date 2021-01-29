import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loan_bazaar/constants/endpoints.dart';
import 'package:loan_bazaar/firebase/dbtools.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InstantLoan {
  String name, link, logo, id, ytid;
  num lowerCost,
      higherCost,
      lowerInterest,
      higherInterest,
      lowerDays,
      higherDays;
  List eligibility;
  Map documents, fees;

  share() {
    //   Uri uri = Uri.https();
    Uri uri = Uri.http(EPS.url, EPS.instantloan, {'id': '$id'});
    Share.share('look i found $uri');
  }

  bool hasData() => name != null;
  Future<InstantLoan> getData() async {
    CollectionReference reference = DBtools().loans;
    var doc = await reference.doc(id).get();
    return fromSnapShot(doc);
  }

  Map toMap() {
    Map<String, dynamic> ret = {
      "documents": documents,
      "eligibility": eligibility,
      "fees": fees,
      "higherCost": higherCost,
      "higherDays": higherDays,
      "higherInterest": higherInterest,
      "link": link,
      "logo": logo,
      "ytid": ytid,
      "lowerCost": lowerCost,
      "lowerDays": lowerDays,
      "lowerInterest": lowerInterest,
      "name": name,
    };
    return ret;
  }

  Widget player() {
    if (ytid == null || ytid.isEmpty) return Container();
    YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: ytid,
      flags: YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
    return YoutubePlayer(controller: controller);
  }

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    if (other is InstantLoan) {
      return other.id == this.id;
    }
    return false;
  }

  static InstantLoan lookup(
      {@required List<InstantLoan> inside, @required InstantLoan what}) {
    inside.map((e) {
      if (e.id == what.id) {
        return e;
      }
    });
  }

  static InstantLoan fromSnapShot(DocumentSnapshot e) {
    Map data = e.data();
    data['id'] = e.id;
    return InstantLoan.fromMap(data);
  }

  static InstantLoan fromMap(Map p) {
    if (!(p['eligibility'] is List)) {
      p['eligibility'] = [];
    }
    return InstantLoan(
        documents: p['documents'],
        eligibility: p['eligibility'],
        fees: p['fees'],
        higherCost: p['higherCost'],
        higherDays: p['higherDays'],
        higherInterest: p['higherInterest'],
        link: p['link'],
        logo: p['logo'],
        lowerCost: p['lowerCost'],
        lowerDays: p['lowerDays'],
        lowerInterest: p['lowerInterest'],
        name: p['name'],
        id: p['id'],
        ytid: p['ytid']);
  }

  InstantLoan(
      {this.documents,
      this.eligibility,
      this.fees,
      this.higherCost,
      this.higherDays,
      this.higherInterest,
      this.link,
      this.logo,
      this.lowerCost,
      this.lowerDays,
      this.lowerInterest,
      this.name,
      this.ytid,
      this.id});
}
