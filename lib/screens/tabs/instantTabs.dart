import 'package:flutter/material.dart';
import 'package:loan_bazaar/adids.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/firebase/dbtools.dart';
import 'package:loan_bazaar/models/instantLoan.dart';
import 'package:loan_bazaar/utils/FBAdUtils.dart';
import 'package:loan_bazaar/widgets/BannerCarousel.dart';
import 'package:loan_bazaar/widgets/InstantLoanCard.dart';
import 'package:url_launcher/url_launcher.dart';

class InstantLoansTab extends StatefulWidget {
  @override
  _InstantLoansTabState createState() => _InstantLoansTabState();
}

class _InstantLoansTabState extends State<InstantLoansTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<InstantLoan>>(
        stream: DBtools().loanStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
              body: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                      onPressed: () async {
                        try {
                          var url = instalink;
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
                      },
                      child: Text('Help')),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.moreoptions);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.more_vert_rounded,
                          size: 30,
                        ),
                      ))
                ],
              ),
              SearchWidgetText(),
              BannerCarousel(),
              FBAdUtils.banner(),
              ...snapshot.data.map((e) {
                return Column(
                  children: [
                    InstantLoanCard(
                      loan: e,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FBAdUtils.banner(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              }).toList()
            ],
          ));
        });
  }
}

class SearchWidgetText extends StatefulWidget {
  const SearchWidgetText({
    Key key,
  }) : super(key: key);

  @override
  _SearchWidgetTextState createState() => _SearchWidgetTextState();
}

class _SearchWidgetTextState extends State<SearchWidgetText> {
  String va;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onSubmitted: (value) => value == null || value.isEmpty
            ? null
            : Navigator.of(context).pushNamed(Routes.search, arguments: value),
        onChanged: (value) => setState(() {
          va = value;
        }),
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5), gapPadding: 0),
        ),
      ),
    );
  }
}
