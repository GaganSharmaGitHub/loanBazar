import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/legal.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';

class LegalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Legal'),
        ),
        body: Builder(builder: (context) {
          return ListView(
            children: [
              ...legal.entries
                  .map((e) => ExpansionTile(
                        title: Text(e.key),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.value),
                          )
                        ],
                      ))
                  .toList()
            ],
          );
        }),
      ),
    );
  }
}
