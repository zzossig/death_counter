import 'package:death_counter/helpers/question_brain.dart';
import 'package:death_counter/screens/result.dart';
import 'package:flutter/material.dart';

class CalcInput extends StatefulWidget {
  @override
  _CalcInputState createState() => _CalcInputState();
}

class _CalcInputState extends State<CalcInput> {
  QuestionBrain qb = new QuestionBrain();

  @override
  Widget build(BuildContext context) {
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
                      qb.getQuestionText,
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
                        for (int i = 0; i < qb.getQuestionAnswers.length; i++)
                          ListTile(
                            title: Text(
                              qb.getQuestionAnswers[i].text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            leading: Radio(
                              value: i,
                              groupValue: qb.getQuestion.selected,
                              onChanged: (value) {
                                setState(() {
                                  // print(value);
                                  qb.getQuestion.selected = value;
                                });
                              },
                            ),
                          ),
                        // Text('11', style: TextStyle(color: Colors.red))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 4.0,
              ),
              child: Row(
                children: <Widget>[
                  for (int i = 0; i < qb.getQuestions.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: qb.getQuestionNumber == i
                              ? Colors.red
                              : Colors.grey[800],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                qb.isFirst()
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FlatButton(
                          child: Text('취소'),
                          color: Theme.of(context).primaryColor,
                          onPressed: () => Navigator.pop(context),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FlatButton(
                          child: Text('뒤로'),
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            setState(() {
                              qb.prevQuestion();
                            });
                          },
                        ),
                      ),
                qb.isFinal()
                    ? FlatButton(
                        child: Text('결과보기'),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResultScreen(),
                            ),
                          );
                        },
                      )
                    : FlatButton(
                        child: Text('다음'),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            qb.nextQuestion();
                          });
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
