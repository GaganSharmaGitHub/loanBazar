import 'package:flutter/material.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferDetails extends StatelessWidget {
  final Map offer;
  OfferDetails(this.offer);
  final TextStyle title =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30);
  TextStyle subtitle(double t) =>
      TextStyle(fontWeight: FontWeight.bold, fontSize: t, color: Colors.black);
  TextStyle sub(double t) => TextStyle(fontSize: t, color: Colors.white);

  @override
  Widget build(BuildContext context) {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: Image.network(
                  '${offer['image']}',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${offer['title']}',
                  style: title,
                ),
              ),
            ],
          ),
        ),
      );
    }

    _launchURL() async {
      try {
        var url = offer['link'];
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
          child: FlatButton(
            onPressed: _launchURL,
            child: Text('Apply now'),
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          actions: [],
        ),
        body: Builder(
            // stream: null,
            builder: (context) {
          return ListView(
            children: [
              TopOfPage(),
              SizedBox(
                height: 10,
              ),
              Text(offer['desc'].toString())
            ],
          );
        }),
      ),
    );
  }
}
