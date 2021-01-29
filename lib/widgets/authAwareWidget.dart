import 'package:flutter/material.dart';
import 'package:loan_bazaar/models/MyExUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loan_bazaar/firebase/auth.dart';
import 'package:loan_bazaar/firebase/user.dart';

typedef Widget AuthBuilder(BuildContext context, ExUser exUser, MyUser user);

class AuthAwareBuilder extends StatelessWidget {
  final AuthBuilder builder;

  final Widget unAuth;

  const AuthAwareBuilder(
      {Key key, @required this.builder, @required this.unAuth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MyUser>(
      stream: AuthServices().user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SizedBox(
            child: CircularProgressIndicator(),
            width: 30,
          ));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return unAuth;
        }
        return StreamBuilder<DocumentSnapshot>(
          stream:
              snapshot.data.usersCollection.doc(snapshot.data.uid).snapshots(),
          builder: (ctx, doc) {
            if (doc.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            Map data = doc.data.data();

            ExUser exuser;
            if (!doc.data.exists || data == null) {
              exuser = ExUser(favourites: []);
              snapshot.data
                  .createUserData(ExUser(favourites: [], name: 'User'));
            } else {
              exuser = ExUser.fromMap(data);
            }

            if (exuser.favourites == null) {
              exuser.favourites = [];
            }
            if (exuser.name == null || exuser.name.isEmpty) {
              exuser.name = 'User';
            }
            return builder(ctx, exuser, snapshot.data);
          },
        );
      },
    );
  }
}
