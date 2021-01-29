import 'package:flutter/material.dart';
//import 'package:connectivity/connectivity.dart';
import 'package:simple_connectivity/simple_connectivity.dart';
import 'package:loan_bazaar/constants/onboardingData.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;
  const ConnectivityWrapper({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            if (snapshot.data == ConnectivityResult.none) {
              return Center(
                child: Image.asset(nonw),
              );
            }
            return child;
          }),
    );
  }
}
