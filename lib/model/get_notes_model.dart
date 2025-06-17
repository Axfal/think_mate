class GetNotesModel {
  bool? success;
  List<Notes>? notes;
  List<Bookmarks>? bookmarks;

  GetNotesModel({this.success, this.notes, this.bookmarks});

  GetNotesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    // Safe check for list
    if (json['notes'] is List) {
      notes = <Notes>[];
      json['notes'].forEach((v) {
        notes!.add(Notes.fromJson(v));
      });
    } else {
      notes = [];
    }

    if (json['bookmarks'] is List) {
      bookmarks = <Bookmarks>[];
      json['bookmarks'].forEach((v) {
        bookmarks!.add(Bookmarks.fromJson(v));
      });
    } else {
      bookmarks = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = this.success;
    if (this.notes != null) {
      data['notes'] = this.notes!.map((v) => v.toJson()).toList();
    }
    if (this.bookmarks != null) {
      data['bookmarks'] = this.bookmarks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Notes {
  int? id;
  int? userId;
  int? testId;
  int? subjectId;
  String? title;
  String? description;
  String? createdAt;
  String? subjectName;
  String? testName;

  Notes(
      {this.id,
        this.userId,
        this.testId,
        this.subjectId,
        this.title,
        this.description,
        this.createdAt,
        this.subjectName,
        this.testName});

  Notes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    testId = json['test_id'];
    subjectId = json['subject_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    subjectName = json['subject_name'];
    testName = json['test_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['test_id'] = this.testId;
    data['subject_id'] = this.subjectId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['subject_name'] = this.subjectName;
    data['test_name'] = this.testName;
    return data;
  }
}

class Bookmarks {
  int? id;
  int? userId;
  int? testId;
  int? questionId;
  String? markStatus;
  String? question;
  String? detail;
  int? subjectId;
  String? testName;

  Bookmarks(
      {this.id,
        this.userId,
        this.testId,
        this.questionId,
        this.markStatus,
        this.question,
        this.detail,
        this.subjectId,
        this.testName});

  Bookmarks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    testId = json['test_id'];
    questionId = json['question_id'];
    markStatus = json['mark_status'];
    question = json['question'];
    detail = json['detail'];
    subjectId = json['subject_id'];
    testName = json['test_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['test_id'] = this.testId;
    data['question_id'] = this.questionId;
    data['mark_status'] = this.markStatus;
    data['question'] = this.question;
    data['detail'] = this.detail;
    data['subject_id'] = this.subjectId;
    data['test_name'] = this.testName;
    return data;
  }
}
