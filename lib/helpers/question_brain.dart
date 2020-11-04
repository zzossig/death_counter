import 'package:death_counter/helpers/answer.dart';

import 'question.dart';

class QuestionBrain {
  int _questionNumber = 0;

  // List<Question> _questionBank = [];
  List<Question> _questionBank = [
    Question(text: 'Question first', answers: [
      Answer(text: "Answer1", score: 0.4),
      Answer(text: "Answer2", score: 0.4),
      Answer(text: "Answer3", score: 0.4),
      Answer(text: "Answer4", score: 0.4),
    ]),
    Question(text: 'Question second', answers: [
      Answer(text: "Answer1", score: 0.4),
      Answer(text: "Answer2", score: 0.4),
      Answer(text: "Answer3", score: 0.4),
      Answer(text: "Answer4", score: 0.4),
    ]),
    Question(text: 'Question Third', answers: [
      Answer(text: "Answer1", score: 0.4),
      Answer(text: "Answer2", score: 0.4),
      Answer(text: "Answer3", score: 0.4),
      Answer(text: "Answer4", score: 0.4),
    ]),
    Question(text: 'Question Forth', answers: [
      Answer(text: "Answer1", score: 0.4),
      Answer(text: "Answer3", score: 0.4),
      Answer(text: "Answer4", score: 0.4),
    ]),
    Question(text: 'Question Fifth', answers: [
      Answer(text: "Answer1", score: 0.4),
      Answer(text: "Answer2", score: 0.4),
      Answer(text: "Answer3", score: 0.4),
      Answer(text: "Answer4", score: 0.4),
    ]),
  ];

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

  void reset() {
    _questionNumber = 0;
  }
}
