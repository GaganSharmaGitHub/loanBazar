import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/widgets/authAwareWidget.dart';

class GoToUser extends StatelessWidget {
  const GoToUser({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthAwareBuilder(
        builder: (context, exUser, user) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 40,
                    child: Text('${exUser?.name[0] ?? "U"}'),
                  ),
                ),
                Text('Hi, ${exUser?.name ?? "User"}'),
                FlatButton(
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.myProfile);
                  },
                  color: Theme.of(context).accentColor,
                  child: Text('My Profile'),
                )
              ],
            ),
          );
        },
        unAuth: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('?'),
            ),
            Text('You\'re not logged in'),
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.login);
              },
              child: Text('Log in'),
              color: Theme.of(context).accentColor,
            )
          ],
        ));
  }
}
