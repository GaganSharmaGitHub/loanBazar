import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/onboardingData.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';
import 'package:loan_bazaar/widgets/gotouser.dart';

class MoreOptionsScreen extends StatelessWidget {
  const MoreOptionsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text('More options'),
        ),
        body: ListView(
          children: [
            GoToUser(),
            ListTile(
              title: Text('Terms and Conditions'),
              onTap: () {
                Navigator.of(context).pushNamed(Routes.tnc);
              },
            ),
            ListTile(
              title: Text('Legal'),
              onTap: () {
                Navigator.of(context).pushNamed(Routes.legal);
              },
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset(
                    applogo,
                    height: 60,
                    width: 60,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
