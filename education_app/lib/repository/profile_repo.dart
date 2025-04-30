import 'package:education_app/resources/exports.dart';

import '../model/change_password_model.dart';
import '../model/profile_model.dart';

class ProfileRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<ProfileModel> getProfileData(int userId) async {
    try {
      final response = await _apiServices
          .getGetApiResponse(AppUrl.profile + userId.toString());
      return ProfileModel.fromJson(response);
    } catch (error) {
      debugPrint('Error while fetching user profile: $error');
      throw Exception('Failed to fetch user profile api');
    }
  }

  Future<ChangePasswordModel> changePassword(
      int userId, String oldPassword, String newPassword) async {
    Map<String, dynamic> data = {
      "user_id": userId,
      "old_password": oldPassword,
      "new_password": newPassword
    };

    try {
      final response =
      await _apiServices.getPostMultipartRequestApiResponse(AppUrl.changePassword, data);

      debugPrint("Change Password API Response: $response");

      return ChangePasswordModel.fromJson(response);
    } catch (error) {
      debugPrint('Error while changing password: $error');
      throw Exception('Failed to change password');
    }
  }

}
