class PastPaperModel {
  bool? success;
  List<Data>? data;

  PastPaperModel({this.success, this.data});

  PastPaperModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? testId;
  int? subjectId;
  int? chapterId;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? option5;
  String? detail;
  String? capacity;
  String? correctAnswer;
  String? pastExam;

  Data(
      {this.id,
        this.testId,
        this.subjectId,
        this.chapterId,
        this.question,
        this.option1,
        this.option2,
        this.option3,
        this.option4,
        this.option5,
        this.detail,
        this.capacity,
        this.correctAnswer,
        this.pastExam});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    testId = json['test_id'];
    subjectId = json['subject_id'];
    chapterId = json['chapter_id'];
    question = json['question'];
    option1 = json['option1'];
    option2 = json['option2'];
    option3 = json['option3'];
    option4 = json['option4'];
    option5 = json['option5'];
    detail = json['detail'];
    capacity = json['capacity'];
    correctAnswer = json['correct_answer'];
    pastExam = json['past_exam'];
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
    data['option5'] = this.option5;
    data['detail'] = this.detail;
    data['capacity'] = this.capacity;
    data['correct_answer'] = this.correctAnswer;
    data['past_exam'] = this.pastExam;
    return data;
  }
}
