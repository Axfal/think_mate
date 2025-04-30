class ResetModel {
  bool? success;
  String? message;

  ResetModel({this.success, this.message});

  ResetModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'] ?? json['error']; // Handle both 'message' and 'error'
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    return data;
  }
}
