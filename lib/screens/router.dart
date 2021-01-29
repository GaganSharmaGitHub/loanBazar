import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/models/creditCards.dart';
import 'package:loan_bazaar/models/instantLoan.dart';
import 'package:loan_bazaar/screens/compareScreen.dart';
import 'package:loan_bazaar/screens/legalscreen.dart';
import 'package:loan_bazaar/screens/mobileSignIn.dart';
import 'package:loan_bazaar/screens/screens.dart';
import 'package:loan_bazaar/screens/searchScreen.dart';
import 'package:loan_bazaar/screens/tandcScreen.dart';
import 'package:loan_bazaar/utils/FBAdUtils.dart';

class Router {
  Router._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (Routes.adroutes.contains(settings.name)) {
      FBAdUtils.showAd();
    }

    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: HomePage(),
          ),
        );
      case Routes.legal:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: LegalScreen(),
          ),
        );
      case Routes.tnc:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: TNCScreen(),
          ),
        );
      case Routes.loggedinhome:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: LoggedInHomeScreen(),
          ),
        );

      case Routes.agreeTC:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: AgreeTNCScreen(),
          ),
        );

      case Routes.asklogin:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: AskLoginScreen(),
          ),
        );
      case Routes.onboard:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: OnBoarding(),
          ),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: AskLoginScreen(),
          ),
        );
      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: AskLoginScreen(),
          ),
        );
      case Routes.mobileSign:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: MobileSignIn(),
          ),
        );
      case Routes.myProfile:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: MyProfilesScreen(),
          ),
        );

      case Routes.myfavs:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Favourites(
              favs: settings.arguments is List ? settings.arguments : [],
            ),
          ),
        );
      case Routes.search:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: SearchLoansScreen(
              name: settings?.arguments?.toString() ?? '',
            ),
          ),
        );

      case Routes.singleOffer:
        return MaterialPageRoute(builder: (_) {
          if (settings.arguments is Map) {
            return Scaffold(
              body: OfferDetails(settings.arguments),
            );
          }

          return Scaffold(
            body: Center(
              child: Text('No offer found'),
            ),
          );
        });
      case Routes.singleLoan:
        return MaterialPageRoute(builder: (_) {
          var args = settings.arguments;
          if (args is InstantLoan) {
            return Scaffold(
              body: LoanDetails(
                loan: args,
              ),
            );
          }
          if (args is String) {
            return Scaffold(
              body: LoanDetails(
                loan: InstantLoan(id: args),
              ),
            );
          }
          if (args is Map) {
            return Scaffold(
              body: LoanDetails(
                loan: InstantLoan(id: args['id']),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: Text('No loan found'),
            ),
          );
        });
      case Routes.compareLoan:
        return MaterialPageRoute(builder: (_) {
          var args = settings.arguments;
          if (args is InstantLoan) {
            return Scaffold(
              body: CompareScreen(
                first: args,
              ),
            );
          }
          if (args is String) {
            return Scaffold(
              body: CompareScreen(
                first: InstantLoan(id: args),
              ),
            );
          }
          if (args is Map) {
            return Scaffold(
              body: CompareScreen(
                first: InstantLoan(id: args['id']),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: Text('No loan found'),
            ),
          );
        });
      case Routes.singleCard:
        return MaterialPageRoute(builder: (_) {
          var args = settings.arguments;
          if (args is CreditCard) {
            return Scaffold(
              body: CreditCardDetails(
                card: args,
              ),
            );
          }
          if (args is String) {
            return Scaffold(
              body: CreditCardDetails(
                card: CreditCard(id: args),
              ),
            );
          }
          if (args is Map) {
            return Scaffold(
              body: CreditCardDetails(
                card: CreditCard(id: args['id']),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: Text('No cards found'),
            ),
          );
        });
      case Routes.moreoptions:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: MoreOptionsScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
