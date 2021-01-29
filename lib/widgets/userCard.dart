import 'package:flutter/material.dart';
import 'package:loan_bazaar/firebase/user.dart';
import 'package:loan_bazaar/models/MyExUser.dart';
import 'package:numberpicker/numberpicker.dart';

class UserCard extends StatefulWidget {
  const UserCard({Key key, this.exuser, this.user}) : super(key: key);
  final ExUser exuser;
  final MyUser user;

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isEditing;
  String name;
  num income;
  bool isloading = false;
  String profession;
  TextEditingController namecont;
  @override
  void didUpdateWidget(UserCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    name = widget.exuser?.name;
    income = widget.exuser?.income;
    profession = widget.exuser?.profession;
    namecont.text = name;
  }

  @override
  void initState() {
    super.initState();
    name = widget.exuser?.name;
    income = widget.exuser?.income;
    profession = widget.exuser?.profession;
    namecont = TextEditingController();
    namecont.text = name;
  }

  List<String> profss = ['Student', 'Salaried', 'Self Employed'];
  @override
  void dispose() {
    namecont.dispose();
    super.dispose();
  }

  bold(String str) => Text(
        str,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
  @override
  Widget build(BuildContext context) {
    return Card(
      child: IgnorePointer(
        ignoring: isloading,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isEditing == true
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 40,
                            child: Text('${widget.exuser?.name[0] ?? "U"}'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              child: Icon(Icons.close),
                              onTap: () {
                                setState(() {
                                  isEditing = false;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          onChanged: (v) => setState(() => name = v),
                          controller: namecont,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  gapPadding: 0),
                              labelText: 'Name'),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        bold('Income'),
                        Row(
                          children: [
                            Text(income?.toString() ?? 'no income'),
                            FlatButton(
                                onPressed: () async {
                                  num p = await showDialog(
                                      context: context,
                                      child: NumberPickerDialog.integer(
                                        minValue: 1000,
                                        maxValue: 100000000,
                                        initialIntegerValue: income,
                                        step: 1000,
                                      ));
                                  setState(() {
                                    income = p;
                                  });
                                },
                                child: Text('Change')),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        bold('Profession'),
                        ButtonBar(
                          children: profss
                              .map((e) => RaisedButton(
                                    onPressed: () =>
                                        setState(() => profession = e),
                                    child: Text(e),
                                    color: e == profession
                                        ? Theme.of(context).accentColor
                                        : Colors.grey,
                                  ))
                              .toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () async {
                              Map<String, dynamic> p = {
                                'income': income,
                                'name': name,
                                'profession': profession
                              };
                              setState(() {
                                isloading = true;
                              });
                              var t = await widget.user.updateData(p);
                              if (t is String) {
                                Scaffold.of(context)
                                    .showSnackBar(SnackBar(content: Text(t)));

                                setState(() {
                                  isloading = false;
                                });
                              } else {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Updated')));

                                setState(() {
                                  isloading = false;
                                });
                              }
                            },
                            child: Text('Save'),
                            color: Theme.of(context).accentColor,
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 40,
                            child: Text('${widget.exuser?.name[0] ?? "U"}'),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            child: Icon(Icons.edit),
                            onTap: () {
                              setState(() {
                                isEditing = true;
                              });
                            },
                          ),
                        ),
                        bold('Name'),
                        Text(name ?? 'No name'),
                        SizedBox(
                          height: 10,
                        ),
                        bold('Income'),
                        Text(income?.toString() ?? 'No income'),
                        SizedBox(
                          height: 10,
                        ),
                        bold('Profession'),
                        Text(profession ?? 'No profession')
                      ],
                    ),
            ),
            isloading ? CircularProgressIndicator() : Container()
          ],
        ),
      ),
    );
  }
}
