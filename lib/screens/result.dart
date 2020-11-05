import 'dart:async';
import 'dart:math';
import 'package:death_counter/screens/intro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:death_counter/widgets/radial_painter.dart';
import 'package:easy_localization/easy_localization.dart';

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
    initialize();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void initialize() async {
    bool isExist = await checkIfExist();

    if (isExist) {
      setToday();
      setRemainingDays();
      startTimer();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => IntroScreen(),
        ),
      );
    }
  }

  Future<bool> checkIfExist() async {
    final prefs = await SharedPreferences.getInstance();
    final lifeSpan = prefs.getDouble('lifeSpan');
    final birthDate = prefs.getString('birthDate');
    final registeredYear = prefs.getInt('registeredYear');

    if (lifeSpan == null || birthDate == null || registeredYear == null) {
      return false;
    }
    return true;
  }

  void setRemainingDays() async {
    final double lifeSpan = await getDoubleData("lifeSpan");
    final String birthDate = await getStringData("birthDate");
    final int registeredYear = await getIntData("registeredYear");

    var rand = new Random();
    int lifeSpanYear = lifeSpan.toInt();
    double lifeSpanRemainder = (lifeSpan - lifeSpanYear.toDouble()) * 100;
    int endDateMonth = (lifeSpanRemainder ~/ 8.33) + 1;
    int endDateDay = rand.nextInt(27) + 1;

    var now = new DateTime.now();
    List<String> birthDateYMD = birthDate.split("-");
    int curAge = now.year - int.parse(birthDateYMD[0]);
    var endDate = DateTime(registeredYear + (lifeSpanYear - curAge), endDateMonth, endDateDay, 0, 0, 1, 1);
    var birthDateDateTime = DateTime(int.parse(birthDateYMD[0]), int.parse(birthDateYMD[1]), int.parse(birthDateYMD[2]), 0, 0, 1, 1);
    var diff = endDate.difference(now);
    var passedDays = now.difference(birthDateDateTime).inDays;
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
      _todayEnd = new DateTime(_today.year, _today.month, _today.day, 23, 59, 59, 999);
      _remainingTime = _todayEnd.difference(now);
    });
  }

  void startTimer() {
    const fiftyMilliseconds = const Duration(milliseconds: 70);
    _timer = new Timer.periodic(fiftyMilliseconds, (timer) {
      setRemainingTimes();
    });
  }

  Future<double> getDoubleData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getDouble(key) ?? 0;

    return data;
  }

  Future<int> getIntData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getInt(key) ?? 0;

    return data;
  }

  Future<String> getStringData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key) ?? 0;

    return data;
  }

  String printHMS(BuildContext context) {
    if (_remainingTime == null) {
      return '00:00:00';
    }

    String locale = context.locale.toString();
    var times = _remainingTime.toString().split(":");

    if (locale == 'ko') {
      return '${times[0]}시 ${times[1]}분 ${times[2].substring(0, 5)}초';
    }
    return '${times[0]}:${times[1]}:${times[2].substring(0, 5)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('msg_title').tr(),
      ),
      drawer: Drawer(
        child: ListView(
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
              title: Text('msg_recalc').tr(),
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
                    Container(
                      width: viewportConstraints.maxWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 20.0,
                                  height: 8.0,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'msg_left',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                  ),
                                ).tr(),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 20.0,
                                  height: 8.0,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Text(
                                  'msg_passed',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                  ),
                                ).tr(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Text('${_remainingPerc != null ? (_remainingPerc * 100).toStringAsFixed(2) : 0}%',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          CustomPaint(
                            size: Size(300, 300),
                            foregroundPainter: RadialPainter(
                              bgColor: Colors.grey,
                              lineColor: Colors.red,
                              percent: _remainingPerc != null ? _remainingPerc : 0,
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
                                            printHMS(context),
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              letterSpacing: 0.4,
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
                                          "${_remainingDays != null ? _remainingDays : 0} ${tr('day')}",
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
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Container(
                              child: Column(
                                children: [
                                  Text('${(_remainingPerc != null ? 100 - _remainingPerc * 100 : 0).toStringAsFixed(2)}%',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 35.0,
                          ),
                        ],
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
