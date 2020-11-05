import 'package:death_counter/helpers/answer.dart';
import 'package:death_counter/helpers/question.dart';
import 'package:death_counter/helpers/question_brain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter, rootBundle;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:death_counter/screens/result.dart';
import 'package:easy_localization/easy_localization.dart';

enum Gender { male, female }

class CalcNextInput extends StatefulWidget {
  CalcNextInput({Key key, @required this.qb}) : super(key: key);
  final QuestionBrain qb;

  @override
  _CalcNextInputState createState() => _CalcNextInputState();
}

class _CalcNextInputState extends State<CalcNextInput> {
  final _formKey = GlobalKey<FormState>();
  String _birthDate;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');
  Gender _gender = Gender.male;
  String _country;
  int _weight;
  int _height;
  List<dynamic> _countries;
  Map<String, dynamic> _lifespanByCountry;

  @override
  void initState() {
    super.initState();
    initialize();
    // _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void initialize() async {
    String countriesStr = await getJson('assets/utils/country.json');
    String lifespanByCountryStr = await getJson('assets/utils/lifespan_by_country.json');
    List<dynamic> countries = jsonDecode(countriesStr);
    Map<String, dynamic> lifespanByCountry = jsonDecode(lifespanByCountryStr);

    setState(() {
      _countries = countries;
      _lifespanByCountry = lifespanByCountry;
    });
  }

  Future<String> getJson(String path) async {
    return await rootBundle.loadString(path);
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('birthDate', _birthDate);

      DateTime now = new DateTime.now();
      prefs.setInt('registeredYear', now.year);

      double lifeSpan = calcLifespan();
      prefs.setDouble('lifeSpan', lifeSpan);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(),
        ),
      );
    }
  }

  double calcLifespan() {
    double countryAvg;
    QuestionBrain qb = widget.qb;
    DateTime now = new DateTime.now();
    int birthYear = int.parse(_birthDate.split("-")[0]);
    int curAge = now.year - birthYear;

    if (_lifespanByCountry.containsKey(_country)) {
      countryAvg = _gender == Gender.male ? _lifespanByCountry[_country]['male'] : _lifespanByCountry[_country]['female'];
    } else {
      countryAvg = 70.0;
    }

    double scoreSum = 0.0;
    for (Question q in qb.getQuestions()) {
      List<Answer> answers = q.getAnswers;
      scoreSum += answers[q.selected].getScore;
    }
    scoreSum += calcBMI();

    double result = scoreSum == 0
        ? countryAvg
        : scoreSum < 0
            ? countryAvg - (scoreSum / 4)
            : countryAvg - (scoreSum / 3);

    if (result <= curAge) {
      result += 4;
    }

    return result;
  }

  double calcBMI() {
    double bmi = _weight / (_height * 0.01 * _height * 0.01);
    // 저체중 / 정상체중 / 위험체중 / 비만 1단계 / 비만 2단계 / 비만 3단계
    double result = 1;

    if (bmi < 18.5) {
      result = 1.0;
    } else if (bmi >= 18.5 && bmi < 23) {
      result = 0;
    } else if (bmi >= 23 && bmi < 25) {
      result = 1.0;
    } else if (bmi >= 25 && bmi < 30) {
      result = 2.0;
    } else if (bmi >= 30 && bmi < 40) {
      result = 4.0;
    } else if (bmi >= 40) {
      result = 7.0;
    }

    return result;
  }

  String birthDayValidator(input) {
    if (input == null || input == "") {
      return tr('validate_birthdate');
    }
    return null;
  }

  String countryValidator(input) {
    if (input == null || input == "") {
      return tr('validate_country');
    }
    return null;
  }

  void _handleDatePicker(BuildContext context) async {
    final DateTime date = await showDatePicker(
      context: context,
      locale: context.locale,
      initialDate: _date,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
        _birthDate = _dateFormatter.format(date);
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.black,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          height: 48,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'required',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 28.0,
                              decoration: TextDecoration.none,
                            ),
                          ).tr(),
                        ),
                        Expanded(
                          // A flexible child that will grow to fit the viewport but
                          // still be at least as big as necessary to fit its contents.
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 28.0,
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      controller: _dateController,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      onTap: () => _handleDatePicker(context),
                                      validator: birthDayValidator,
                                      decoration: InputDecoration(
                                        labelText: tr('birthdate'),
                                        labelStyle: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey,
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 28.0),
                                      child: Text(
                                        'gender',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey,
                                        ),
                                      ).tr(),
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: Gender.male,
                                          groupValue: _gender,
                                          activeColor: Theme.of(context).primaryColor,
                                          onChanged: (Gender value) {
                                            setState(() {
                                              _gender = value;
                                            });
                                          },
                                        ),
                                        Text('male').tr(),
                                        SizedBox(width: 24.0),
                                        Radio(
                                          value: Gender.female,
                                          groupValue: _gender,
                                          activeColor: Theme.of(context).primaryColor,
                                          onChanged: (Gender value) {
                                            setState(() {
                                              _gender = value;
                                            });
                                          },
                                        ),
                                        Text('female').tr(),
                                      ],
                                    ),
                                    DropdownButtonFormField<String>(
                                      value: _country,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      iconSize: 16,
                                      style: TextStyle(color: Colors.white),
                                      isExpanded: true,
                                      validator: countryValidator,
                                      decoration: InputDecoration(
                                        labelText: tr('country'),
                                        labelStyle: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _country = newValue;
                                        });
                                      },
                                      items: _countries != null
                                          ? _countries.map((value) {
                                              return DropdownMenuItem(
                                                value: value['code'].toString(),
                                                child: Text(value['name'].toString()),
                                              );
                                            }).toList()
                                          : [],
                                    ),
                                    SizedBox(height: 12.0),
                                    TextFormField(
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: tr('height'),
                                        labelStyle: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey,
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      keyboardType: TextInputType.number,
                                      validator: (input) {
                                        if (input == null || input.trim().isEmpty || int.parse(input.trim()) <= 50 || int.parse(input.trim()) >= 230) {
                                          return tr('validate_height');
                                        }
                                        return null;
                                      },
                                      onChanged: (input) {
                                        setState(() {
                                          _height = int.parse(input);
                                        });
                                      },
                                    ),
                                    SizedBox(height: 20.0),
                                    TextFormField(
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: tr('weight'),
                                        labelStyle: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey,
                                        ),
                                        enabledBorder: const UnderlineInputBorder(
                                          // width: 0.0 produces a thin "hairline" border
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      keyboardType: TextInputType.number,
                                      validator: (input) {
                                        if (input == null || input.trim().isEmpty || int.parse(input.trim()) <= 20 || int.parse(input.trim()) >= 200) {
                                          return tr('validate_weight');
                                        }
                                        return null;
                                      },
                                      onChanged: (input) {
                                        setState(() {
                                          _weight = int.parse(input);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 70.0,
                          alignment: Alignment.center,
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: Text(
                                  'back',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ).tr(),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FlatButton(
                                child: Text('save').tr(),
                                color: Colors.blue[800],
                                onPressed: _submit,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
