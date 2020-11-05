import 'package:death_counter/helpers/answer.dart';
import 'package:death_counter/helpers/question.dart';
import 'package:death_counter/helpers/question_brain.dart';
import 'package:death_counter/screens/calc_next_input.dart';
import 'package:death_counter/screens/intro.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CalcInput extends StatefulWidget {
  CalcInput({Key key, @required this.locale}) : super(key: key);
  final String locale;

  @override
  _CalcInputState createState() => _CalcInputState();
}

class _CalcInputState extends State<CalcInput> {
  QuestionBrain _qb = new QuestionBrain();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    String questionsStr = await getJson('assets/utils/questions_${widget.locale}.json');
    List<dynamic> questions = jsonDecode(questionsStr);

    QuestionBrain qb = new QuestionBrain();
    for (var q in questions) {
      Question newQ = new Question(text: q['question'], answers: []);
      var answers = q['answers'];
      for (var a in answers) {
        var answer = new Answer(text: a['text'], score: a['score']);
        newQ.addAnswer(answer);
      }

      qb.addQuestion(newQ);
    }

    setState(() {
      _qb = qb;
    });
  }

  Future<String> getJson(String path) async {
    return await rootBundle.loadString(path);
  }

  void _submit() async {
    if (_qb.getQuestion().selected < 0) {
      _showMyDialog();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CalcNextInput(qb: _qb),
        ),
      );
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.white),
              children: <InlineSpan>[
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 4.0,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 24.0,
                      semanticLabel: tr('q_alert_title'),
                    ),
                  ),
                ),
                TextSpan(text: tr('q_alert_title')),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'q_alert_msg1',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ).tr(),
                Text(
                  'q_alert_msg2',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ).tr(),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('confirm').tr(),
              color: Colors.grey[900],
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_qb.size() <= 0) {
      return Container(
        child: Text('loading').tr(),
      );
    }
    return SafeArea(
      child: Material(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      _qb.getQuestionText(),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 28.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        for (var i = 0; i < _qb.getQuestion().getAnswers.length; i++)
                          ListTile(
                            title: Text(
                              _qb.getQuestion().getAnswers[i].text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            leading: Radio(
                              value: i,
                              activeColor: Colors.red,
                              focusColor: Colors.blue,
                              hoverColor: Colors.green,
                              groupValue: _qb.getQuestion().selected,
                              onChanged: (value) {
                                setState(() {
                                  _qb.getQuestion().selected = value;
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Wrap(
                spacing: 8.0,
                children: <Widget>[
                  for (int i = 0; i < _qb.getQuestions().length; i++)
                    Text(
                      '${i + 1}',
                      style: TextStyle(
                        color: _qb.getQuestionNumber() == i ? Theme.of(context).primaryColor : Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _qb.isFirst()
                    ? FlatButton(
                        child: Text('cancel').tr(),
                        color: Colors.grey[900],
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => IntroScreen(),
                            ),
                          );
                        },
                      )
                    : FlatButton(
                        child: Text('back').tr(),
                        color: Colors.grey[900],
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            _qb.prevQuestion();
                          });
                        },
                      ),
                _qb.isFinal()
                    ? FlatButton(
                        child: Text('next').tr(),
                        color: Colors.grey[900],
                        textColor: Colors.white,
                        onPressed: _submit,
                      )
                    : FlatButton(
                        child: Text('next').tr(),
                        color: Colors.grey[900],
                        textColor: Colors.white,
                        onPressed: () {
                          if (_qb.getQuestion().selected < 0) {
                            _showMyDialog();
                          } else {
                            setState(() {
                              _qb.nextQuestion();
                            });
                          }
                        },
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
