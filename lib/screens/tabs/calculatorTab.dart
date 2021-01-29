import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loan_bazaar/utils/FBAdUtils.dart';
import 'package:numberpicker/numberpicker.dart';

class CalculatorTab extends StatefulWidget {
  CalculatorTab({Key key}) : super(key: key);

  @override
  _CalculatorTabState createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<CalculatorTab> {
  bool isNotOkay() =>
      principle == null ||
      principle < 50000 ||
      rate == null ||
      years == null ||
      months == null ||
      (months == 0 && years == 0);
  num principle = 0;
  num rate = 1;
  num years = 0;
  num months = 0;
  num totalMonths() => (years * 12) + months;
  num emi() {
    if (isNotOkay()) {
      return 0;
    } else {
      num rn = pow((rate / 100) + 1, totalMonths());
      return (principle * rate * (rn / (rn - 1)) / 100).ceil() * 1.0;
    }
  }

  num totalinterest() {
    if (isNotOkay()) {
      return 0;
    } else {
      return totalAmount() - principle;
    }
  }

  num totalAmount() {
    if (isNotOkay()) {
      return 0;
    } else {
      num t = totalMonths();
      return emi() * t;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle ct = TextStyle(fontSize: 15, color: Colors.white);
    TextStyle cv = TextStyle(
        fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              color: Theme.of(context).accentColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Loan amount',
                            style: ct,
                          ),
                          Text(
                            '₹ $principle',
                            style: cv,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Monthly EMI',
                            style: ct,
                          ),
                          Text(
                            '₹ ${emi()}',
                            style: cv,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total payable amount',
                            style: ct,
                          ),
                          Text(
                            '₹ ${totalAmount()}',
                            style: cv,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Total Interest',
                            style: ct,
                          ),
                          Text(
                            '₹ ${totalinterest()}',
                            style: cv,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Loan Amount:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  value = value.replaceAll(',', '');
                  num val = double.tryParse(value);
                  if (val != null) {
                    principle = val;
                  }
                });
              },
              keyboardType:
                  TextInputType.numberWithOptions(signed: false, decimal: true),
              validator: (value) {
                value = value.replaceAll('₹', '');
                value = value.replaceAll(',', '');
                num val = double.tryParse(value);
                if (val == null) {
                  return 'Enter valid value';
                }
                if (val < 50000) {
                  return 'Enter value greater than 50,000';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.always,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    child: Text('₹'),
                    radius: 10,
                  ),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5), gapPadding: 0),
              ),
              maxLines: 1,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Time:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                FlatButton(
                  onPressed: () async {
                    num p = await showDialog(
                      context: context,
                      child: NumberPickerDialog.integer(
                        minValue: 0,
                        maxValue: 40,
                        initialIntegerValue: years ?? 1,
                        step: 1,
                        title: Text('Select years'),
                      ),
                    );
                    if (p == null) {
                      return;
                    }
                    setState(() {
                      years = p;
                    });
                  },
                  child: Text('$years years'),
                ),
                FlatButton(
                    onPressed: () async {
                      num p = await showDialog(
                        context: context,
                        child: NumberPickerDialog.integer(
                          minValue: 0,
                          maxValue: 12,
                          initialIntegerValue: months ?? 1,
                          step: 1,
                          title: Text('Select years'),
                        ),
                      );
                      if (p == null) {
                        return;
                      }
                      setState(() {
                        months = p;
                      });
                    },
                    child: Text('$months months')),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rate:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('$rate %')
              ],
            ),
            Slider.adaptive(
              value: rate.toDouble(),
              onChanged: (i) {
                setState(() {
                  rate = i.ceil();
                });
              },
              min: 1,
              max: 40,
            ),
            SizedBox(
              height: 20,
            ),
            FBAdUtils.banner(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
