class IncorrectQuestionModel {
  bool? success;
  List<IncorrectQuestions>? incorrectQuestions;

  IncorrectQuestionModel({this.success, this.incorrectQuestions});

  IncorrectQuestionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['incorrect_questions'] != null) {
      incorrectQuestions = <IncorrectQuestions>[];
      json['incorrect_questions'].forEach((v) {
        incorrectQuestions!.add(new IncorrectQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.incorrectQuestions != null) {
      data['incorrect_questions'] =
          this.incorrectQuestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IncorrectQuestions {
  int? id;
  int? testId;
  int? subjectId;
  int? chapterId;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? detail;
  String? capacity;
  String? correctAnswer;

  IncorrectQuestions(
      {this.id,
      this.testId,
      this.subjectId,
      this.chapterId,
      this.question,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.detail,
      this.capacity,
      this.correctAnswer});

  IncorrectQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    testId = json['test_id'];
    subjectId = json['subject_id'];
    chapterId = json['chapter_id'];
    question = json['question'];
    option1 = json['option1'];
    option2 = json['option2'];
    option3 = json['option3'];
    option4 = json['option4'];
    detail = json['detail'];
    capacity = json['capacity'];
    correctAnswer = json['correct_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['test_id'] = this.testId;
    data['subject_id'] = this.subjectId;
    data['chapter_id'] = this.chapterId;
    data['question'] = this.question;
    data['option1'] = this.option1;
    data['option2'] = this.option2;
    data['option3'] = this.option3;
    data['option4'] = this.option4;
    data['detail'] = this.detail;
    data['capacity'] = this.capacity;
    data['correct_answer'] = this.correctAnswer;
    return data;
  }
}
