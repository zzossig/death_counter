import 'package:death_counter/screens/result.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

class SelfInput extends StatefulWidget {
  @override
  _SelfInputState createState() => _SelfInputState();
}

class _SelfInputState extends State<SelfInput> {
  final _formKey = GlobalKey<FormState>();
  double _lifeSpan;
  String _birthDate;
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    // _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final prefs = await SharedPreferences.getInstance();
      prefs.setDouble('lifeSpan', _lifeSpan);
      prefs.setString('birthDate', _birthDate);

      DateTime now = new DateTime.now();
      prefs.setInt('registeredYear', now.year);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(),
        ),
      );
    }
  }

  String lifeSpanValidator(input) {
    if (input == null || input.trim().isEmpty) {
      return tr('validate_no_lifespan');
    }
    return null;
  }

  String birthDayValidator(input) {
    if (input == null || input == "") {
      return tr('validate_birthdate');
    } else if (_lifeSpan == null || _lifeSpan <= 0) {
      return tr('validate_lifespan');
    }

    List<String> birthDateYMD = input.split("-");
    DateTime now = new DateTime.now();
    int curAge = now.year - int.parse(birthDateYMD[0]);

    if (_lifeSpan <= curAge.toDouble()) {
      return tr('validate_lifespan');
    }
    return null;
  }

  void _handleDatePicker(BuildContext context) async {
    final DateTime date = await showDatePicker(
      context: context,
      locale: context.locale,
      initialDate: _date,
      firstDate: DateTime(1920),
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'self_title',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  decoration: TextDecoration.none,
                ),
              ).tr(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: tr('lifespan'),
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
                      validator: lifeSpanValidator,
                      onChanged: (input) {
                        setState(() {
                          _lifeSpan = double.parse(input);
                        });
                      },
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
                        enabledBorder: const UnderlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            'cancel',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
