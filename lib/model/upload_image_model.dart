class UploadImageModel {
  final bool? success;
  final String? message;

  UploadImageModel({this.success, this.message});

  factory UploadImageModel.fromJson(Map<String, dynamic> json) {
    return UploadImageModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
