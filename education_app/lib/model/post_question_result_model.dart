class PostTestResultModel {
  bool? success;
  String? message;
  int? examId;
  String? date;

  PostTestResultModel({this.success, this.message, this.examId, this.date});

  PostTestResultModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    examId = json['exam_id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['exam_id'] = this.examId;
    data['date'] = this.date;
    return data;
  }
}
