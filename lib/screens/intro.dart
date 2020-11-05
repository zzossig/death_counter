import 'package:death_counter/screens/calc_input.dart';
import 'package:death_counter/screens/self_input.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  String dropdownValue;

  @override
  void initState() {
    super.initState();

    new Future.delayed(Duration.zero, () {
      setState(() {
        dropdownValue = context.locale.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, right: 20.0),
                      child: dropdownValue == null
                          ? Text('loading').tr()
                          : Container(
                              alignment: Alignment.centerRight,
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                icon: Icon(Icons.keyboard_arrow_down_rounded),
                                iconSize: 16,
                                iconEnabledColor: Colors.deepPurpleAccent,
                                elevation: 16,
                                style: TextStyle(color: Colors.white),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String newValue) {
                                  context.locale = Locale(newValue);
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                },
                                items: <String>['en', 'ko'].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value).tr(),
                                  );
                                }).toList(),
                              ),
                            ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'intro_title',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.0,
                                decoration: TextDecoration.none,
                              ),
                            ).tr(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    child: Text(
                                      'intro_self',
                                      style: TextStyle(color: Colors.white),
                                    ).tr(),
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SelfInput(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    child: Text(
                                      'intro_calc',
                                      style: TextStyle(color: Colors.white),
                                    ).tr(),
                                    color: Theme.of(context).accentColor,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CalcInput(locale: dropdownValue),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
