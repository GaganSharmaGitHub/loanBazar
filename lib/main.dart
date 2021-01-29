import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loan_bazaar/screens/homeScreen.dart';
import 'package:loan_bazaar/screens/router.dart' as R;
import 'package:facebook_audience_network/facebook_audience_network.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FacebookAudienceNetwork.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Bazaar',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: R.Router.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'ok'),
    );
  }
}
