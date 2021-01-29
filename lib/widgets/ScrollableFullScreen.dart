import 'package:flutter/material.dart';

class ScrollableFullScreen extends StatelessWidget {
  final Widget child;
  ScrollableFullScreen({this.child});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: child,
      ),
    );
  }
}
