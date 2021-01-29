import 'package:loan_bazaar/constants/onboardingData.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/firebase/auth.dart';
import 'package:flutter/material.dart';
import 'package:loan_bazaar/firebase/user.dart';
import 'package:loan_bazaar/models/MyExUser.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';

class SignUpForm extends StatefulWidget {
  final AuthServices _auth = AuthServices();
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Container(
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
                      'Sign Up to Loan Bazaar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Enter your Name:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Johhny',
                  prefixIcon: Icon(Icons.account_circle),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5), gapPadding: 0),
                ),
                maxLines: 1,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Enter your Email:',
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
                      borderRadius: BorderRadius.circular(5), gapPadding: 0),
                ),
                maxLines: 1,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Create Password:',
                style: TextStyle(fontWeight: FontWeight.bold),
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
                      borderRadius: BorderRadius.circular(5), gapPadding: 0),
                ),
                maxLines: 1,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Confirm Password:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    confirmPassword = value;
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
                      borderRadius: BorderRadius.circular(5), gapPadding: 0),
                ),
                maxLines: 1,
              ),
              SizedBox(
                height: 10,
              ),
              FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person_add,
                      size: 20,
                    ),
                    Text(
                      '  Register',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                onPressed: () async {
                  if (password != confirmPassword) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Password and confirm password do not match')));
                  } else {
                    dynamic result = await widget._auth.newUserCreate(
                        email: email,
                        password: password,
                        info: ExUser(favourites: [], name: name));
                    if (result is MyUser) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.loggedinhome, (route) => true);
                      return;
                    }
                    if (result is String) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(result)));
                    }
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Couldn\'t sign you in')));
                  }
                },
                color: Theme.of(context).accentColor,
              ),
              Center(
                  child: Text(
                'Already an account?',
                style: TextStyle(fontStyle: FontStyle.italic),
              )),
              Center(
                  child: FlatButton(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed(Routes.login),
                child: Text(
                  'Log In',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ))
            ],
          ),
        ),
      )),
    );
  }
}
