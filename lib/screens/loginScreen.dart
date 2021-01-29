import 'package:loan_bazaar/constants/onboardingData.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:loan_bazaar/firebase/auth.dart';
import 'package:loan_bazaar/firebase/user.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email = '';
  String password = '';
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image(
                            image: AssetImage(applogo),
                            width: 60,
                          ),
                        ),
                        Text(
                          'Log In to Loan Bazaar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Enter Email:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'example@email.com',
                      prefixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 0),
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Enter Password:',
                    style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: isVisible,
                    decoration: InputDecoration(
                      hintText: '********',
                      suffixIcon: InkWell(
                        child: Icon(isVisible
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined),
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                      ),
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          gapPadding: 0),
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            size: 20,
                          ),
                          Text(
                            '  Log In',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () async {
                      final AuthServices _auth = AuthServices();

                      dynamic result = await _auth.signInEmailPass(
                        email: email,
                        password: password,
                      );

                      if (result is MyUser) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.loggedinhome, (route) => true);
                        return;
                      }
                      if (result is String) {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text(result)));
                        return;
                      }

                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Couldn\'t log you in')));
                    },
                    color: Theme.of(context).accentColor,
                  ),
                  Center(
                      child: Text(
                    'Not a user yet?',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )),
                  Center(
                      child: FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(Routes.register);
                    },
                    child: Text(
                      'Sign up now',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
