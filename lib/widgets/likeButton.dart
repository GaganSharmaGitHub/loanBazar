import 'package:flutter/material.dart';
import 'package:loan_bazaar/constants/routes.dart';
import 'package:loan_bazaar/widgets/authAwareWidget.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    return AuthAwareBuilder(
      builder: (context, exUser, user) {
        if (exUser.favourites == null || !exUser.favourites.contains(id)) {
          return IconButton(
            icon: Icon(Icons.book_outlined),
            onPressed: () async {
              if (exUser.favourites == null) {
                exUser.favourites = [];
              }
              exUser.favourites.add(id);
              Map<String, dynamic> d = {'favourites': exUser.favourites};
              var res = await user.updateData(d);
              String mess = 'Added to favourites';
              if (res is String) {
                mess = res;
              }
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(mess)));
            },
          );
        }
        return IconButton(
          icon: Icon(Icons.book),
          onPressed: () async {
            exUser.favourites.remove(id);
            Map<String, dynamic> d = {'favourites': exUser.favourites};
            var res = await user.updateData(d);
            String mess = 'Removed from favourites';
            if (res is String) {
              mess = res;
            }
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(mess)));
          },
        );
      },
      unAuth: IconButton(
        icon: Icon(Icons.book_outlined),
        onPressed: () {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('Login to save favourites')),
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
      ),
    );
  }
}
