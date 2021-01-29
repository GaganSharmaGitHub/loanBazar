import 'package:flutter/material.dart';
import 'package:loan_bazaar/screens/tabs/calculatorTab.dart';
import 'package:loan_bazaar/screens/tabs/creditCardTab.dart';
import 'package:loan_bazaar/screens/tabs/tabs.dart';
import 'package:loan_bazaar/utils/FBAdUtils.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';

class LoggedInHomeScreen extends StatefulWidget {
  LoggedInHomeScreen({Key key}) : super(key: key);

  @override
  _LoggedInHomeScreenState createState() => _LoggedInHomeScreenState();
}

class _LoggedInHomeScreenState extends State<LoggedInHomeScreen> {
  PageController controller;
  int currentIndex = 0;

  void onTabTapped(int value) {
    controller.animateToPage(value,
        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    setState(() {
      currentIndex = value;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      InstantLoansTab(),
      CreditCardTab(),
      OffersTab(),
      CalculatorTab(),
    ];
    return ConnectivityWrapper(
      child: Scaffold(
        body: PageView(
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
            FBAdUtils.showAd();
          },
          children: tabs,
          controller: controller,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped, //
          currentIndex: currentIndex, //
          selectedItemColor: Theme.of(context).accentColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Text(
                '₹',
                style: TextStyle(
                    fontSize: 20,
                    color: currentIndex == 0
                        ? Theme.of(context).accentColor
                        : Colors.grey),
              ),
              label: 'Loans',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card_outlined),
              label: 'Credit Cards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.redeem_outlined),
              label: 'Offers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              label: 'Calculator',
            )
          ],
        ),
      ),
    );
  }
}
