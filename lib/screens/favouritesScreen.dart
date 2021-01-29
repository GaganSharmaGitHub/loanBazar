import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/firebase/dbtools.dart';
import 'package:loan_bazaar/models/instantLoan.dart';
import 'package:loan_bazaar/widgets/connectivityAwareWrapper.dart';

class Favourites extends StatelessWidget {
  final List favs;
  const Favourites({Key key, this.favs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectivityWrapper(
      child: Scaffold(
        body: Builder(builder: (context) {
          if (favs == null || favs.isEmpty) {
            return Center(
              child: Text('No favourites added yet'),
            );
          }
          return ListView(
            children: favs
                .map((e) => FavouriteTile(
                      id: e,
                    ))
                .toList(),
          );
        }),
        appBar: AppBar(
          title: Text('Favourites'),
        ),
      ),
    );
  }
}

class FavouriteTile extends StatelessWidget {
  const FavouriteTile({Key key, this.id}) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InstantLoan>(
        future: DBtools().singleLoan(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(
              title: LinearProgressIndicator(),
            );
          }
          if (snapshot.hasError || snapshot.data == null) {
            return ListTile(
              leading: Icon(Icons.error),
              title: Text('${snapshot?.error ?? "Card not found"}'),
            );
          }
          return ListTile(
            leading: Icon(Icons.book),
            title: Text('${snapshot.data.name}'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(Routes.singleLoan, arguments: snapshot.data);
            },
          );
        });
  }
}
