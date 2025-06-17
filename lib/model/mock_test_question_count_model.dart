class MockTestQuestionCountModel {
  bool? success;
  int? totalAvailable;
  String? message;

  MockTestQuestionCountModel({this.success, this.totalAvailable, this.message});

  MockTestQuestionCountModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    totalAvailable = json['total_available'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['total_available'] = this.totalAvailable;
    data['message'] = this.message;
    return data;
  }
}
