class HintModel {
  bool? success;
  List<Data>? data;

  HintModel({this.success, this.data});

  HintModel.fromJson(Map<String, dynamic> json) {
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
  int? testId;
  int? subjectId;
  String? hintText;

  Data({this.testId, this.subjectId, this.hintText});

  Data.fromJson(Map<String, dynamic> json) {
    testId = json['test_id'];
    subjectId = json['subject_id'];
    hintText = json['hint_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['test_id'] = this.testId;
    data['subject_id'] = this.subjectId;
    data['hint_text'] = this.hintText;
    return data;
  }
}
