import 'package:flutter/material.dart';

class ShareApplyButton extends StatelessWidget {
  const ShareApplyButton({Key key, this.onTap, this.child}) : super(key: key);
  final Function onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: child,
          )),
    );
  }
}
