import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/firebase/auth.dart';
import 'package:loan_bazaar/widgets/authAwareWidget.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';
import 'package:loan_bazaar/widgets/userCard.dart';

class MyProfilesScreen extends StatelessWidget {
  const MyProfilesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
          appBar: AppBar(
            title: Text('My Profile'),
          ),
          body: AuthAwareBuilder(
            builder: (context, exUser, user) => ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UserCard(
                    exuser: exUser,
                    user: user,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text('Favourites'),
                  onTap: () => Navigator.of(context)
                      .pushNamed(Routes.myfavs, arguments: exUser?.favourites),
                  enabled: true,
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () => AuthServices().signOut(),
                  enabled: true,
                ),
              ],
            ),
            unAuth: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Text('?'),
                  ),
                  Text('You\'re not logged in'),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(Routes.login);
                    },
                    child: Text('Log in'),
                    color: Theme.of(context).accentColor,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
