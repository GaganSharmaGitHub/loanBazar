import 'package:cloud_firestore/cloud_firestore.dart';

class Banner {
  String id;
  String link;
  String image;
  String desc;
  static Banner fromSnapshot(DocumentSnapshot e) {
    Map m = e.data();
    m['id'] = e.id;
    return fromMap(m);
  }

  Map toMap() => {'link': link, 'image': image, 'desc': desc};
  static Banner fromMap(Map m) {
    return Banner(
      desc: m['desc'],
      id: m['id'],
      image: m['image'],
      link: m['link'],
    );
  }

  Banner({this.desc, this.id, this.image, this.link});
}
