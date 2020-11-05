import 'package:death_counter/helpers/answer.dart';

import 'question.dart';

class QuestionBrain {
  int _questionNumber = 0;

  List<Question> _questionBank = [];

  void nextQuestion() {
    if (_questionNumber < _questionBank.length - 1) {
      _questionNumber++;
    }
  }

  void prevQuestion() {
    if (_questionNumber > 0) {
      _questionNumber--;
    }
  }

  void addQuestion(Question question) {
    _questionBank.add(question);
  }

  Question getQuestion() {
    return _questionBank[_questionNumber];
  }

  List<Question> getQuestions() {
    return _questionBank;
  }

  int getQuestionNumber() {
    return _questionNumber;
  }

  String getQuestionText() {
    return _questionBank[_questionNumber].text;
  }

  List<Answer> getQuestionAnswers() {
    return _questionBank[_questionNumber].answers;
  }

  bool isFirst() {
    return _questionNumber == 0;
  }

  bool isFinal() {
    return _questionNumber == _questionBank.length - 1;
  }

  int size() {
    return _questionBank.length;
  }

  void reset() {
    _questionNumber = 0;
  }
}
