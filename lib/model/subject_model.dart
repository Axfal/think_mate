class SubjectModel {
  bool? success;
  List<Subjects>? subjects;

  SubjectModel({this.success, this.subjects});

  SubjectModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['subjects'] != null) {
      subjects = <Subjects>[];
      json['subjects'].forEach((v) {
        subjects!.add(Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.subjects != null) {
      data['subjects'] = this.subjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subjects {
  int? id;
  int? testId;
  String? subjectName;

  Subjects({this.id, this.testId, this.subjectName});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    testId = json['test_id'];
    subjectName = json['subject_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['test_id'] = this.testId;
    data['subject_name'] = this.subjectName;
    return data;
  }
}
