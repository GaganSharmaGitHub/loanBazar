import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/models/instantLoan.dart';
import 'package:loan_bazaar/utils/formating.dart';
import 'package:loan_bazaar/widgets/applyShare.dart';

class InstantLoanCard extends StatelessWidget {
  const InstantLoanCard({
    Key key,
    @required this.loan,
  }) : super(key: key);

  final InstantLoan loan;

  @override
  Widget build(BuildContext context) {
    share() {
      loan.share();
    }

    open() {
      Navigator.of(context).pushNamed(Routes.singleLoan, arguments: loan);
    }

    final TextStyle title = TextStyle(
        color: Theme.of(context).accentColor,
        fontWeight: FontWeight.bold,
        fontSize: 20);
    TextStyle subtitle(double t) => TextStyle(
        fontWeight: FontWeight.bold, fontSize: t, color: Colors.black);
    TextStyle sub(double t) => TextStyle(fontSize: t, color: Colors.grey);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).accentColor),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 4.0),
              blurRadius: 4.0,
            ),
          ],
          color: Theme.of(context).cardColor,
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: InkWell(
            onTap: open,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          loan.name,
                          style: title,
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '${loan?.lowerCost?.toCurrecyWords()}-${loan?.higherCost?.toCurrecyWords()}',
                              style: subtitle(20),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Loan Amount',
                              style: sub(10),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Wrap(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text:
                                          '${loan?.lowerInterest?.roundTwoPlaces()}%-${loan?.higherInterest?.roundTwoPlaces()}%',
                                      style: subtitle(15),
                                      children: [
                                        TextSpan(
                                            text: '\nDaily Interest',
                                            style: sub(10)),
                                      ]),
                                ),
                                RichText(
                                  text: TextSpan(
                                      text:
                                          '${loan?.lowerDays}-${loan?.higherDays} days',
                                      style: subtitle(15),
                                      children: [
                                        TextSpan(
                                            text: '\nTime Period',
                                            style: sub(10)),
                                      ]),
                                ),
                              ],
                              alignment: WrapAlignment.spaceBetween,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            ShareApplyButton(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    Routes.compareLoan,
                                    arguments: loan);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                child: Text(
                                  'Compare',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                            ),
                            ShareApplyButton(
                              onTap: share,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                child: Text(
                                  'Share',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: -20,
                  right: -20,
                  child: ClipOval(
                    child: Container(
                      color: Theme.of(context).accentColor.withOpacity(0.5),
                      padding: EdgeInsets.all(30),
                      child: Hero(
                        tag: loan.id,
                        child: Image.network(
                          loan.logo,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
