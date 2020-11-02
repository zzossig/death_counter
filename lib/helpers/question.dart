import 'package:death_counter/helpers/answer.dart';

class Question {
  Question({this.text, this.answers});

  final String text;
  List<Answer> answers = [];
  int _selected = -1;

  int get getCorrectAnswerNumber {
    for (int i = 0; i < answers.length; i++) {
      if (answers[i].isCollect) {
        return i + 1;
      }
    }
    return -1;
  }

  Answer get getCorrectAnswer {
    for (int i = 0; i < answers.length; i++) {
      if (answers[i].isCollect) {
        return answers[i];
      }
    }
    return null;
  }

  int get selected {
    return _selected;
  }

  set selected(int selected) {
    this._selected = selected;
  }
}
