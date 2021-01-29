import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/utils/formating.dart';
import 'package:flutter/material.dart';
import 'package:loan_bazaar/firebase/dbtools.dart';
import 'package:loan_bazaar/models/instantLoan.dart';
import 'package:loan_bazaar/widgets/authAwareWidget.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';
import 'package:loan_bazaar/widgets/eligibility.dart';
import 'package:loan_bazaar/widgets/likeButton.dart';
import 'package:loan_bazaar/widgets/table.dart';
import 'package:url_launcher/url_launcher.dart';

class LoanDetails extends StatefulWidget {
  final InstantLoan loan;
  const LoanDetails({Key key, this.loan}) : super(key: key);

  @override
  _LoanDetailsState createState() => _LoanDetailsState();
}

class _LoanDetailsState extends State<LoanDetails> {
  InstantLoan loan;
  @override
  void initState() {
    super.initState();

    loan = widget.loan;

    if (loan.name == null) {
      getData();
    }
  }

  getData() async {
    try {
      loan = await DBtools().singleLoan(loan.id);
      setState(() {});
    } catch (e) {
      showDialog(
          context: context,
          barrierDismissible: false,
          child: AlertDialog(
            content: Text(e is String ? e : "Could not find loan"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          ));
    }
  }

  Widget TopOfPage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 4.0),
            blurRadius: 4.0,
          ),
        ],
        color: Theme.of(context).accentColor,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                        text: '\nTime Period', style: sub(10)),
                                  ]),
                            ),
                          ],
                          alignment: WrapAlignment.spaceBetween,
                        ),
                      ],
                    ),
                  ),
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
    );
  }

  final TextStyle title =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30);
  TextStyle subtitle(double t) =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: t, color: Colors.black);
  TextStyle sub(double t) => TextStyle(fontSize: t, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    if (loan == null || loan.name == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    _launchURL() async {
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

    return ConnectivityWrapper(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AuthAwareBuilder(
            builder: (context, exUser, user) => FlatButton(
              onPressed: _launchURL,
              child: Text('Apply now'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
            ),
            unAuth: FlatButton(
              onPressed: () {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Login to apply')),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.login);
                      },
                      child: Text('Login'),
                      color: Theme.of(context).accentColor,
                    )
                  ],
                )));
              },
              child: Text('Login to apply'),
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: loan.share,
            ),
            LikeButton(
              id: loan.id,
            ),
          ],
        ),
        body: Builder(
            // stream: null,
            builder: (context) {
          return ListView(
            children: [
              TopOfPage(),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: loan.player(),
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Eligibilty(
                  eligibity: loan?.eligibility ?? ['no criteria'],
                ),
              ),
              Divider(
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: TableFromMap(
                  data: loan.documents,
                  title: Text(
                    'Documents',
                    style: subtitle(20),
                  ),
                ),
              ),
              Divider(
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: TableFromMap(
                  data: loan.fees,
                  title: Text(
                    'Fees',
                    style: subtitle(20),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
