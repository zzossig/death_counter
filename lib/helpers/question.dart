import 'package:death_counter/helpers/answer.dart';

class Question {
  Question({this.text, this.answers});

  final String text;
  List<Answer> answers = [];
  int _selected = -1;

  List<Answer> get getAnswers {
    return answers;
  }

  void addAnswer(Answer answer) {
    print(this.answers);
    this.answers.add(answer);
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
