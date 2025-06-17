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
      int userId, String oldPassword, String newPassword, String confirmPassword) async {
    Map<String, dynamic> data = {
      "user_id": userId,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
      "old_password": oldPassword,
    };

    try {
      final response = await _apiServices.getPostMultipartRequestApiResponse(
          AppUrl.changePassword, data);

      debugPrint("Change Password API Response: $response");

      return ChangePasswordModel.fromJson(response);
    } catch (error) {
      debugPrint('Error while changing password: $error');
      throw Exception('Failed to change password');
    }
  }

  Future<dynamic> updateProfileApi(dynamic data) async {
    try {
      debugPrint("Updating profile with data: $data");


      final response = await _apiServices.getPostMultipartRequestApiResponse(
        AppUrl.changePassword,
        data,
      );

      debugPrint("Profile update response: $response");
      return response;
    } catch (e) {
      debugPrint("Error in updateProfileApi: $e");
      rethrow;
    }
  }

  Future<dynamic> updatePasswordApi(dynamic data) async {
    try {
      final response = await _apiServices.getPostApiResponse(
        '${AppUrl.baseUrl}/update_password.php',
        data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
