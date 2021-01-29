import 'package:flutter/material.dart';
import 'package:loan_bazaar/firebase/dbtools.dart';
import 'package:loan_bazaar/models/instantLoan.dart';
import 'package:loan_bazaar/utils/FBAdUtils.dart';
import 'package:loan_bazaar/widgets/InstantLoanCard.dart';

class SearchLoansScreen extends StatelessWidget {
  final String name;
  SearchLoansScreen({this.name});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<InstantLoan>>(
        stream: DBtools().queryloanStream(
          name: name,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
              appBar: AppBar(
                title: Text('$name'),
              ),
              body: snapshot.data.length == 0
                  ? Center(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('No results found'),
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Go Back'),
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                        )
                      ],
                    ))
                  : ListView(
                      children: [
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
