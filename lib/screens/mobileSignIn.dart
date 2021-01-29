import 'package:firebase_auth/firebase_auth.dart';
import 'package:loan_bazaar/constants/onboardingData.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/firebase/auth.dart';
import 'package:flutter/material.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class MobileSignIn extends StatefulWidget {
  @override
  _MobileSignInState createState() => _MobileSignInState();
}

class _MobileSignInState extends State<MobileSignIn> {
  String number;

  submit() async {
    if (!verify()) {
      return showSnackBar('Please enter valide phone number');
    }
    AuthServices auth = AuthServices();
    await auth.auth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (phoneAuthCredential) async {
        AuthCredential creds;
        if (phoneAuthCredential.token != null) {
          creds = PhoneAuthProvider.credentialFromToken(
              phoneAuthCredential.token,
              smsCode: phoneAuthCredential.smsCode);
        } else if (phoneAuthCredential.verificationId != null) {
          creds = PhoneAuthProvider.credential(
              verificationId: phoneAuthCredential.verificationId,
              smsCode: phoneAuthCredential.smsCode);
        } else {
          return;
        }
        var user = await auth.auth.signInWithCredential(creds);
        if (user != null) {
          await auth.setSp();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.loggedinhome, (route) => true);
        }
      },
      verificationFailed: (error) => Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(error.message))),
      codeSent: (verificationId, forceResendingToken) async {
        String code = await showModalBottomSheet(
          context: context,
          builder: (context) => BottomSheetSMS(),
        );
        if (code != null) {
          AuthCredential creds = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: code);
          var user = await auth.auth.signInWithCredential(creds);
          if (user != null) {
            await auth.setSp();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.loggedinhome, (route) => true);
            return;
          }
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Row(
          children: [
            Text('Could not auto retrieve code'),
            FlatButton(
                onPressed: () async {
                  String code = await showModalBottomSheet(
                    context: context,
                    builder: (context) => BottomSheetSMS(),
                  );
                  if (code != null) {
                    AuthCredential creds = PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: code);
                    var user = await auth.auth.signInWithCredential(creds);
                    if (user != null) {
                      await auth.setSp();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Routes.loggedinhome, (route) => true);
                      return;
                    }
                  }
                },
                child: Text('Enter code'))
          ],
        )));
      },
    );
  }

  verify() => number != null && number.length > 9;
  showSnackBar(t) {
    print(t);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$t'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
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
                  'Enter Your phone number:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    setState(() {
                      number = phone.completeNumber;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  textColor: Colors.white,
                  onPressed: submit,
                  child: Text('Send OTP'),
                  color: Theme.of(context).accentColor,
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

class BottomSheetSMS extends StatefulWidget {
  @override
  _BottomSheetSMSState createState() => _BottomSheetSMSState();
}

class _BottomSheetSMSState extends State<BottomSheetSMS> {
  String code;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'Enter SMS code:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            onChanged: (value) {
              setState(() {
                code = value;
              });
            },
            keyboardType: TextInputType.phone,
            maxLengthEnforced: true,
            decoration: InputDecoration(
              hintText: '******',
              prefixIcon: Icon(Icons.mail_outline),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5), gapPadding: 0),
            ),
            maxLines: 1,
          ),
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop(code);
              },
              child: Text('Verify'))
        ],
      ),
    );
  }
}
