import 'package:death_counter/screens/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelfInput extends StatefulWidget {
  @override
  _SelfInputState createState() => _SelfInputState();
}

class _SelfInputState extends State<SelfInput> {
  final _formKey = GlobalKey<FormState>();
  int _lifeSpan;

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('lifeSpan', _lifeSpan);

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
                    TextFormField(
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: '기대 수명',
                        labelStyle:
                            TextStyle(fontSize: 18.0, color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      validator: (input) =>
                          input.trim().isEmpty ? '기대수명을 입력해주세요.' : null,
                      onSaved: (input) => _lifeSpan = int.parse(input),
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
