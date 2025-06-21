class UserTestDataModel {
  bool? success;
  List<Data>? data;

  UserTestDataModel({this.success, this.data});

  UserTestDataModel.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  int? questionId;
  String? questionResult;
  int? selectedOption;
  int? chapterId;
  String? date;

  Data(
      {this.id,
        this.userId,
        this.questionId,
        this.questionResult,
        this.selectedOption,
        this.chapterId,
        this.date});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    questionId = json['question_id'];
    questionResult = json['question_result'];
    selectedOption = json['selected_option'];
    chapterId = json['chapter_id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['question_id'] = this.questionId;
    data['question_result'] = this.questionResult;
    data['selected_option'] = this.selectedOption;
    data['chapter_id'] = this.chapterId;
    data['date'] = this.date;
    return data;
  }
}
