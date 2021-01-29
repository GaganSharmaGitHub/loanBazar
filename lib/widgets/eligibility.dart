import 'package:flutter/material.dart';

class Eligibilty extends StatelessWidget {
  final List eligibity;
  final String title;
  const Eligibilty({this.eligibity, this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? 'Eligibility',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 10,
        ),
        ...eligibity.map((e) => Text('✓$e \n')).toList()
      ],
    );
  }
}
