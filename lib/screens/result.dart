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
  int _remainingDays;
  DateTime _today = new DateTime.now();
  DateTime _todayEnd;
  Duration _remainingTime;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    setToday();
    setRemainingDays();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void setRemainingDays() async {
    final lifeSpan = await getIntData("lifeSpan");
    final curAge = await getIntData("curAge");
    final registeredYear = await getIntData("registeredYear");

    var now = new DateTime.now();
    var endDate = DateTime(
        registeredYear + (lifeSpan - curAge), DateTime.july, 1, 00, 00, 1, 1);
    var diff = endDate.difference(now);
    var remainingDays = diff.inDays - 1; // -1 for countdown time

    setState(() {
      _remainingDays = remainingDays;
    });
  }

  void setRemainingTimes() {
    var now = new DateTime.now();
    var diff = _todayEnd.difference(now);

    if (diff.isNegative) {
      setState(() {
        _remainingDays -= 1;
        setToday();
      });
    } else {
      setState(() {
        _remainingTime = diff;
      });
    }
  }

  void setToday() {
    var now = new DateTime.now();
    setState(() {
      _today = new DateTime.now();
      _todayEnd =
          new DateTime(_today.year, _today.month, _today.day, 23, 59, 59, 999);
      _remainingTime = _todayEnd.difference(now);
    });
  }

  void startTimer() {
    const fiftyMilliseconds = const Duration(milliseconds: 70);
    _timer = new Timer.periodic(fiftyMilliseconds, (timer) {
      setRemainingTimes();
    });
  }

  Future<int> getIntData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getInt(key) ?? 0;

    if (data <= 0 || data == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => IntroScreen(),
        ),
      );
    }

    return data;
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("$_remainingDays"),
                    Text("${_remainingTime.toString().substring(0, 12)}"),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.grey, width: 2),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black87.withOpacity(0.5),
                      Colors.black54.withOpacity(0.7),
                      Colors.black38.withOpacity(0.9),
                    ],
                    stops: [0.1, 0.4, 0.6, 0.9],
                  ),
                  // backgroundBlendMode:
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
