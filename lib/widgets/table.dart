import 'package:flutter/material.dart';

class TableFromMap extends StatelessWidget {
  final Widget title;
  final Map data;
  TableFromMap({this.data, this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        SizedBox(
          width: double.infinity,
          child: DataTable(
            columns: [
              DataColumn(
                  label: SizedBox(
                height: 0,
              )),
              DataColumn(
                  label: SizedBox(
                height: 0,
              )),
            ],
            headingRowHeight: 15,
            rows: data.keys
                .map((e) => DataRow(cells: [
                      DataCell(Text(e.toString())),
                      DataCell(Text(data[e].toString())),
                    ]))
                .toList(),
          ),
        ),
      ],
    );
  }
}
