import 'dart:async';
import 'package:death_counter/screens/intro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _lifeSpan;

  @override
  void initState() {
    super.initState();

    getLifeSpan();
  }

  void getLifeSpan() async {
    final prefs = await SharedPreferences.getInstance();
    final lifeSpan = prefs.getInt('lifeSpan') ?? 0;

    testStopwatch();

    setState(() {
      if (lifeSpan > 0) {
        _lifeSpan = lifeSpan;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => IntroScreen(),
          ),
        );
      }
    });
  }

  void testStopwatch() {
    final Stopwatch stopwatch = new Stopwatch();
    stopwatch.start();
    print('${stopwatch.elapsedMilliseconds}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('죽음 카운트'),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Memento Mori',
                      style: TextStyle(
                        fontSize: 24.0,
                      )),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('다시 계산하기'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => IntroScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$_lifeSpan'),
        ],
      ),
    );
  }
}
