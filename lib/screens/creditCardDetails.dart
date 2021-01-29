import 'package:loan_bazaar/models/creditCards.dart';
import 'package:flutter/material.dart';
import 'package:loan_bazaar/firebase/dbtools.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';
import 'package:loan_bazaar/widgets/eligibility.dart';
import 'package:loan_bazaar/widgets/table.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditCardDetails extends StatefulWidget {
  final CreditCard card;
  const CreditCardDetails({Key key, this.card}) : super(key: key);

  @override
  _CreditCardDetailsState createState() => _CreditCardDetailsState();
}

class _CreditCardDetailsState extends State<CreditCardDetails> {
  CreditCard card;
  @override
  void initState() {
    super.initState();
    card = widget.card;

    if (card.name == null) {
      getData();
    }
  }

  getData() async {
    try {
      card = await DBtools().singleCard(card.id);

      setState(() {});
    } catch (e) {
      showDialog(
          context: context,
          barrierDismissible: false,
          child: Column(
            children: [
              Text(e is String ? e : "Could not find loan"),
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
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Hero(
                tag: card.id,
                child: Image.network(
                  card.logo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                card.name,
                style: title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                card.bank,
                style: sub(15),
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
    _launchURL() async {
      try {
        var url = card.link;
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

    if (card == null || card.name == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return ConnectivityWrapper(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            onPressed: _launchURL,
            child: Text('Apply now'),
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: card.share,
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
                child: Eligibilty(
                  eligibity: card?.benefits ?? ['no benefits'],
                  title: 'Benefits',
                ),
              ),
              Divider(
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: TableFromMap(
                  data: card.documents,
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
                  data: card.fees,
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
