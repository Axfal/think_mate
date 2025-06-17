class ChangePasswordModel {
  bool? success;
  String? message;
  String? error;

  ChangePasswordModel({this.success, this.message, this.error});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (success != null) data['success'] = success;
    if (message != null) data['message'] = message;
    if (error != null) data['error'] = error;
    return data;
  }
}
