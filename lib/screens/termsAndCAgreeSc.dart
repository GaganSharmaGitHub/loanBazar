import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/onboardingData.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/constants/termsAndConditions.dart';

class AgreeTNCScreen extends StatefulWidget {
  const AgreeTNCScreen({Key key}) : super(key: key);

  @override
  _AgreeTNCScreenState createState() => _AgreeTNCScreenState();
}

class _AgreeTNCScreenState extends State<AgreeTNCScreen> {
  bool agreed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              applogo,
              height: 90,
            ),
          ),
          TNC(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Checkbox(
              value: agreed,
              onChanged: (value) {
                setState(() {
                  agreed = value;
                });
              },
            ),
            title: Text('I have read and accepted terms and conditions'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              textColor: Colors.white,
              child: Text('Next'),
              color: agreed ? Theme.of(context).accentColor : null,
              onPressed: agreed
                  ? () {
                      Navigator.of(context).pushNamed(Routes.asklogin);
                    }
                  : null,
            ),
          )
        ],
      ),
    );
  }
}
