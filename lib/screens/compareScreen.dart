import 'package:flutter/material.dart';
import 'package:loan_bazaar/firebase/dbtools.dart';
import 'package:loan_bazaar/models/instantLoan.dart';
import 'package:loan_bazaar/widgets/CompareHalf.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';

class CompareScreen extends StatefulWidget {
  final InstantLoan first;
  CompareScreen({Key key, this.first}) : super(key: key);

  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  InstantLoan first;
  InstantLoan second;
  @override
  void initState() {
    super.initState();
    first = widget.first;
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Compare'),
        ),
        body: StreamBuilder<List<InstantLoan>>(
            stream: DBtools().loanStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }

              if (first != null && !first.hasData()) {
                first = InstantLoan.lookup(inside: snapshot.data, what: first);
              }
              List<InstantLoan> data = snapshot.data;
              data = data.toSet().toList();
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                DropdownButton<InstantLoan>(
                                  items: snapshot.data
                                      .map(
                                        (e) => DropdownMenuItem<InstantLoan>(
                                          child: Text('${e?.name}'),
                                          value: e,
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        first = value;
                                      },
                                    );
                                  },
                                  value: first,
                                ),
                                CompareHalf(
                                  loan: first,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              child: Column(
                            children: [
                              DropdownButton<InstantLoan>(
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                items: snapshot.data
                                    .map(
                                      (e) => DropdownMenuItem<InstantLoan>(
                                        child: Text('${e?.name}'),
                                        value: e,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      second = value;
                                    },
                                  );
                                },
                                value: second,
                              ),
                              CompareHalf(
                                loan: second,
                              )
                            ],
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
