import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/onboardingData.dart';
import 'package:loan_bazaar/constants/termsAndConditions.dart';

class TNCScreen extends StatelessWidget {
  const TNCScreen({Key key}) : super(key: key);

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
    );
  }
}
