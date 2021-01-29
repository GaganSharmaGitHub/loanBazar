import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/screens/onboarding.dart';
import 'package:loan_bazaar/screens/screens.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  checkLink() async {
    PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    final deeplink = data?.link;
    handleLink(deeplink);
  }

  handleLink(Uri deeplink) {
    if (deeplink == null) {
      return;
    }
    if (deeplink.pathSegments.contains('instantloan')) {
      Navigator.of(context)
          .pushNamed(Routes.singleLoan, arguments: deeplink.queryParameters);
    } else if (deeplink.pathSegments.contains('creditcard')) {
      Navigator.of(context)
          .pushNamed(Routes.singleCard, arguments: deeplink.queryParameters);
    }
  }

  onLink() async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (linkData) async {
        final deeplink = linkData.link;
        print(deeplink);
        handleLink(deeplink);
      },
      onError: (error) async {
        print(error.message);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkLink();
    onLink();
  }

  Future<bool> checkUser(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var result = preferences.get('userLoggedIn');
    if (result == true || result != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
        body: FutureBuilder<bool>(
            initialData: null,
            future: checkUser(context),
            builder: (context, snapshot) {
              if (snapshot.data == null || !snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == true) {
//                return LoggedInHomeScreen();
              }
              return OnBoarding();
            }),
      ),
    );
  }
}
