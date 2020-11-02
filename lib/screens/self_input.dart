import 'package:death_counter/screens/result.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:death_counter/widgets/input_number.dart';

class SelfInput extends StatefulWidget {
  @override
  _SelfInputState createState() => _SelfInputState();
}

class _SelfInputState extends State<SelfInput> {
  final _formKey = GlobalKey<FormState>();
  int _lifeSpan;
  int _curAge;

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('lifeSpan', _lifeSpan);
      prefs.setInt('curAge', _curAge);

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
                '직접 입력',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  decoration: TextDecoration.none,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputNumber(
                      labelText: "기대 수명",
                      validatorText: "기대수명을 입력해주세요.",
                      onSaved: (input) {
                        setState(() {
                          _lifeSpan = int.parse(input);
                        });
                      },
                    ),
                    InputNumber(
                      labelText: "현재 나이",
                      validatorText: "현재 나이를 입력해주세요.",
                      onSaved: (input) {
                        setState(() {
                          _curAge = int.parse(input);
                        });
                      },
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text('저장'),
                          color: Theme.of(context).primaryColor,
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
