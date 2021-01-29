import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/models/creditCards.dart';
import 'package:loan_bazaar/widgets/applyShare.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditCardCard extends StatelessWidget {
  const CreditCardCard({
    Key key,
    @required this.card,
  }) : super(key: key);

  final CreditCard card;
  String benefits() {
    String ts = '';
    for (var s in card.benefits) {
      ts += '✓$s \n';
    }
    return ts;
  }

  share() {
    card.share();
  }

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

    open() {
      Navigator.of(context).pushNamed(Routes.singleCard, arguments: card);
    }

    final TextStyle title = TextStyle(
        color: Theme.of(context).accentColor,
        fontWeight: FontWeight.bold,
        fontSize: 20);
    TextStyle subtitle(double t) => TextStyle(fontSize: t, color: Colors.grey);
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
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              card.name,
                              style: title,
                            ),
                            Divider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  '${card?.bank ?? ''}',
                                  style: subtitle(15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text.rich(TextSpan()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Hero(
                          tag: card?.id ?? DateTime.now(),
                          child: Image.network(
                            card.logo,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Text(
                    '${benefits()}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: sub(15),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      ShareApplyButton(
                        onTap: _launchURL,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Text(
                            'Apply',
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
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
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
