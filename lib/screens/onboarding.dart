import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/onboardingData.dart';
import 'package:loan_bazaar/constants/routes.dart';

class OnBoarding extends StatelessWidget {
  OnBoarding({
    Key key,
  }) : super(key: key);
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    Widget create(Map m, {bool islast}) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('${m['image']}'),
              alignment: Alignment.center,
              fit: BoxFit.contain,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                islast == true
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(Routes.agreeTC);
                            },
                            textColor: Colors.white,
                            child: Text('Let\'s Go'),
                            color: Theme.of(context).accentColor),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: FlatButton(
                            onPressed: () {
                              _controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            },
                            textColor: Colors.white,
                            child: Text('Next'),
                            color: Theme.of(context).accentColor),
                      )
              ],
            ),
          ),
        ),
      );
    }

    return PageView(
      controller: _controller,
      children: onboardingData
          .asMap()
          .keys
          .map((e) => create(
                onboardingData[e],
                islast: e == onboardingData.length - 1,
              ))
          .toList(),
    );
  }
}
