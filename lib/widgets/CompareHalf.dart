import 'package:loan_bazaar/utils/formating.dart';
import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/onboardingData.dart';
import 'package:loan_bazaar/models/instantLoan.dart';
import 'package:url_launcher/url_launcher.dart';

class CompareHalf extends StatelessWidget {
  const CompareHalf({Key key, this.loan}) : super(key: key);
  final InstantLoan loan;

  TextStyle subtitle(double t) =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: t, color: Colors.black);
  TextStyle sub(double t) => TextStyle(fontSize: t, color: Colors.grey);
  @override
  Widget build(BuildContext context) {
    var ln = loan;
    bool isDta = true;
    ImageProvider im;

    if (ln == null) {
      im = AssetImage(applogo);
      isDta = false;
      ln = InstantLoan(
          higherCost: 0,
          higherInterest: 0,
          higherDays: 0,
          lowerCost: 0,
          lowerDays: 0,
          lowerInterest: 0,
          name: 'Please Select a loan');
    } else {
      im = NetworkImage(ln.logo);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: im,
          height: 60,
          fit: BoxFit.cover,
        ),
        Text(
          '\nLoan amount',
          style: sub(10),
        ),
        Text(
          '${ln?.lowerCost?.toCurrecyWords()}-${ln?.higherCost?.toCurrecyWords()}',
          style: subtitle(15),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          '\nDaily Interest',
          style: sub(10),
        ),
        Text(
          '${ln?.lowerInterest?.roundTwoPlaces()}%-${ln?.higherInterest?.roundTwoPlaces()}%',
          style: subtitle(15),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          '\nDaily Interest',
          style: sub(10),
        ),
        Text(
          '${ln?.lowerDays}-${ln?.higherDays} days',
          style: subtitle(15),
        ),
        SizedBox(
          height: 20,
        ),
        FlatButton(
          onPressed: isDta && ln.link != null
              ? () async {
                  try {
                    var url = loan.link;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('$e'),
                    ));
                  }
                }
              : null,
          child: Text('Apply'),
          color: Theme.of(context).accentColor,
        )
      ],
    );
  }
}
