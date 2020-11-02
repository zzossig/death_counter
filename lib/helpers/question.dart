import 'package:death_counter/helpers/answer.dart';

class Question {
  Question({this.text, this.answers});

  final String text;
  List<Answer> answers = [];
  int _selected = -1;

  int get getCorrectAnswerNumber {
    for (int i = 0; i < answers.length; i++) {
      if (answers[i].isCorrect) {
        return i + 1;
      }
    }
    return -1;
  }

  Answer get getCorrectAnswer {
    for (int i = 0; i < answers.length; i++) {
      if (answers[i].isCorrect) {
        return answers[i];
      }
    }
    return null;
  }

  List<Answer> get getAnswers {
    return answers;
  }

  String get getText {
    return text;
  }

  int get selected {
    return _selected;
  }

  set selected(int selected) {
    this._selected = selected;
  }

  void initSelected() {
    this._selected = -1;
  }
}
