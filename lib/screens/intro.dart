import 'package:death_counter/screens/calc_input.dart';
import 'package:death_counter/screens/self_input.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
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
                          builder: (_) => CalcInput(),
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
    );
  }
}
