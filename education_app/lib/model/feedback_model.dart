// ignore_for_file: prefer_collection_literals

class FeedbackModel {
  bool? success;
  String? message;

  FeedbackModel({this.success, this.message});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}
