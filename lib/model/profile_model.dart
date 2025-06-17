class ProfileModel {
  bool? success;
  User? user;

  ProfileModel({this.success, this.user});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? userId;
  String? username;
  String? email;
  String? phone;
  String? address;
  String? profileImage;
  String? updatedAt;

  User(
      {this.userId,
      this.username,
      this.email,
      this.phone,
      this.address,
      this.profileImage,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    profileImage = json['profile_image'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['profile_image'] = this.profileImage;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
