class GetBookMarkModel {
  bool? success;
  List<Bookmarks>? bookmarks;

  GetBookMarkModel({this.success, this.bookmarks});

  GetBookMarkModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['bookmarks'] != null) {
      bookmarks = <Bookmarks>[];
      json['bookmarks'].forEach((v) {
        bookmarks!.add(new Bookmarks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.bookmarks != null) {
      data['bookmarks'] = this.bookmarks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Bookmarks {
  int? userId;
  int? testId;
  int? questionId;
  String? markStatus;
  String? date;

  Bookmarks(
      {this.userId, this.testId, this.questionId, this.markStatus, this.date});

  Bookmarks.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    testId = json['test_id'];
    questionId = json['question_id'];
    markStatus = json['mark_status'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['test_id'] = this.testId;
    data['question_id'] = this.questionId;
    data['mark_status'] = this.markStatus;
    data['date'] = this.date;
    return data;
  }
}
