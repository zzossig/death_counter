import 'dart:async';
import 'package:death_counter/screens/intro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:death_counter/widgets/radial_painter.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _remainingDays;
  double _remainingPerc;
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
        registeredYear + (lifeSpan - curAge), DateTime.july, 1, 0, 0, 1, 1);
    var birthDate =
        DateTime(registeredYear - curAge, DateTime.july, 1, 0, 0, 1, 1);
    var diff = endDate.difference(now);
    var passedDays = now.difference(birthDate).inDays;
    var remainingDays = diff.inDays - 1; // -1 for countdown time
    var remainingPerc = passedDays / (remainingDays + passedDays);

    setState(() {
      _remainingDays = remainingDays;
      _remainingPerc = remainingPerc;
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
    var times = _remainingTime.toString().split(":");

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
            ListTile(
              title: Text('판단 근거'),
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
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text('${(_remainingPerc * 100).toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                )),
          ),
          SizedBox(
            height: 12.0,
          ),
          CustomPaint(
            size: Size(300, 300),
            foregroundPainter: RadialPainter(
              bgColor: Colors.grey,
              lineColor: Colors.red,
              percent: _remainingPerc,
              width: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${times[0]}시 ${times[1]}분 ${times[2].substring(0, 6)}초",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 7,
                            blurRadius: 7,
                            offset: Offset(0, 0),
                          ),
                        ],
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
                    Positioned.fill(
                      top: -50,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "$_remainingDays 일",
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: 50,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "남았습니다",
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
