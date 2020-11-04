import 'package:death_counter/helpers/question.dart';
import 'package:death_counter/helpers/question_brain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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

      int lifespan = calcLifespan();

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => ResultScreen(),
      //   ),
      // );
    }
  }

  int calcLifespan() {
    double countryAvg;
    QuestionBrain qb = widget.qb;

    if (_lifespanByCountry.containsKey(_country)) {
      countryAvg = _gender == Gender.male ? _lifespanByCountry[_country]['male'] : _lifespanByCountry[_country]['female'];
    } else {
      countryAvg = 70.0;
    }

    for (Question q in qb.getQuestions()) {
      print(q.selected);
    }

    return 1;
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
                        Container(
                          height: 120.0,
                          alignment: Alignment.center,
                          child: Text(
                            'required',
                            style: TextStyle(
                              color: Colors.white,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                      padding: const EdgeInsets.only(top: 48.0),
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
                                          activeColor: Theme.of(context).accentColor,
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
                                          activeColor: Theme.of(context).accentColor,
                                          onChanged: (Gender value) {
                                            setState(() {
                                              _gender = value;
                                            });
                                          },
                                        ),
                                        Text('female').tr(),
                                      ],
                                    ),
                                    SizedBox(height: 20.0),
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
