class GetCheckedQuestionModel {
  bool? success;
  List<CheckMarkQuestions>? checkMarkQuestions;

  GetCheckedQuestionModel({this.success, this.checkMarkQuestions});

  GetCheckedQuestionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['Check Mark Questions'] != null) {
      checkMarkQuestions = <CheckMarkQuestions>[];
      json['Check Mark Questions'].forEach((v) {
        checkMarkQuestions!.add(new CheckMarkQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.checkMarkQuestions != null) {
      data['Check Mark Questions'] =
          this.checkMarkQuestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CheckMarkQuestions {
  int? userId;
  int? testId;
  int? questionId;
  int? subjectId;
  int? chapterId;
  String? markStatus;
  String? date;

  CheckMarkQuestions(
      {this.userId,
      this.testId,
      this.questionId,
      this.subjectId,
      this.chapterId,
      this.markStatus,
      this.date});

  CheckMarkQuestions.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    testId = json['test_id'];
    questionId = json['question_id'];
    subjectId = json['subject_id'];
    chapterId = json['chapter_id'];
    markStatus = json['mark_status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['test_id'] = this.testId;
    data['question_id'] = this.questionId;
    data['subject_id'] = this.subjectId;
    data['chapter_id'] = this.chapterId;
    data['mark_status'] = this.markStatus;
    data['date'] = this.date;
    return data;
  }
}
