import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan_bazaar/models/MyExUser.dart';

class MyUser {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final String uid;
  MyUser({
    this.uid,
  });
  Future deleteUserData() async {
    DocumentReference docrefer = usersCollection.doc(uid);
    await docrefer.delete();
  }

  Future createUserData(ExUser userData) async {
    DocumentReference docrefer = usersCollection.doc(uid);
    await docrefer.set(userData.toMap());
  }

  Stream<ExUser> userStream() {
    DocumentReference docrefer = usersCollection.doc(uid);
    Stream<ExUser> k = docrefer.snapshots().map<ExUser>((event) {
      if (!event.exists) {
        createUserData(ExUser(
          favourites: [],
        ));

        return ExUser(favourites: []);
      }
      return ExUser.fromMap(event.data());
    });
    return k;
  }

  Future updateData(Map update) async {
    try {
      final DocumentReference doc = usersCollection.doc(uid);
      await doc.set(update, SetOptions(merge: true));
    } catch (e) {
      if (e is String) {
        return '$e';
      }

      if (e is FirebaseException) {
        return '${e.message}';
      }
      return '$e';
    }
  }
}
