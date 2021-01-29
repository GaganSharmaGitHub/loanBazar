import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/onboardingData.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/firebase/auth.dart';
import 'package:loan_bazaar/firebase/user.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AskLoginScreen extends StatelessWidget {
  const AskLoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
        body: Builder(builder: (context) {
          return ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: Theme.of(context).accentColor,
                ),
                clipBehavior: Clip.hardEdge,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                  child: Image.asset(
                    applogo,
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.mobileSign);
                      },
                      child: Text('Login with phone'),
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: GoogleLoginBTN(),
                  ),
                  FlatButton(
                    child: Text('Skip'),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('userLoggedIn', true);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.loggedinhome, (route) => true);
                    },
                  )
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

class GoogleLoginBTN extends StatelessWidget {
  const GoogleLoginBTN({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      onPressed: () async {
        var res = await AuthServices().googleSignIN();
        if (res is String) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(res)));
          return;
        } else if (res is MyUser) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.loggedinhome, (route) => true);
          return;
        }
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Couldn\'t log you in')));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            googlelogo,
            height: 20,
            width: 20,
          ),
          SizedBox(
            width: 10,
          ),
          Text('Sign in with Google'),
        ],
      ),
      color: Theme.of(context).accentColor,
    );
  }
}
