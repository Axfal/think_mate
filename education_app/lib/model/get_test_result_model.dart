class GetTestResultModel {
  bool? success;
  Test? test;
  List<ExamResults>? examResults;

  GetTestResultModel({this.success, this.test, this.examResults});

  GetTestResultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    test = json['test'] != null ? new Test.fromJson(json['test']) : null;
    if (json['exam_results'] != null) {
      examResults = <ExamResults>[];
      json['exam_results'].forEach((v) {
        examResults!.add(new ExamResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.test != null) {
      data['test'] = this.test!.toJson();
    }
    if (this.examResults != null) {
      data['exam_results'] = this.examResults!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Test {
  int? id;
  String? testName;

  Test({this.id, this.testName});

  Test.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    testName = json['test_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['test_name'] = this.testName;
    return data;
  }
}

class ExamResults {
  int? examId;
  String? date;
  String? examType;
  Overall? overall;
  List<Subjects>? subjects;

  ExamResults(
      {this.examId, this.date, this.examType, this.overall, this.subjects});

  ExamResults.fromJson(Map<String, dynamic> json) {
    examId = json['exam_id'];
    date = json['date'];
    examType = json['exam_type'];
    overall =
        json['overall'] != null ? new Overall.fromJson(json['overall']) : null;
    if (json['subjects'] != null) {
      subjects = <Subjects>[];
      json['subjects'].forEach((v) {
        subjects!.add(new Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exam_id'] = this.examId;
    data['date'] = this.date;
    data['exam_type'] = this.examType;
    if (this.overall != null) {
      data['overall'] = this.overall!.toJson();
    }
    if (this.subjects != null) {
      data['subjects'] = this.subjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Overall {
  int? correct;
  int? incorrect;
  String? percentage;
  String? status;

  Overall({this.correct, this.incorrect, this.percentage, this.status});

  Overall.fromJson(Map<String, dynamic> json) {
    correct = json['correct'];
    incorrect = json['incorrect'];
    percentage = json['percentage'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['correct'] = this.correct;
    data['incorrect'] = this.incorrect;
    data['percentage'] = this.percentage;
    data['status'] = this.status;
    return data;
  }
}

class Subjects {
  int? subjectId;
  String? subjectName;
  int? correct;
  int? incorrect;
  int? total;
  String? percentage;
  String? status;

  Subjects(
      {this.subjectId,
      this.subjectName,
      this.correct,
      this.incorrect,
      this.total,
      this.percentage,
      this.status});

  Subjects.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    correct = json['correct'];
    incorrect = json['incorrect'];
    total = json['total'];
    percentage = json['percentage'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_id'] = this.subjectId;
    data['subject_name'] = this.subjectName;
    data['correct'] = this.correct;
    data['incorrect'] = this.incorrect;
    data['total'] = this.total;
    data['percentage'] = this.percentage;
    data['status'] = this.status;
    return data;
  }
}
