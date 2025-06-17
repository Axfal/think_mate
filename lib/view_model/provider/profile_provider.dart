import 'package:education_app/model/profile_model.dart';
import 'package:education_app/repository/profile_repo.dart';
import 'package:education_app/resources/exports.dart';
import 'package:education_app/utils/toast_helper.dart';

import '../../model/change_password_model.dart';

class ProfileProvider with ChangeNotifier {
  final profileRepo = ProfileRepository();

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  ChangePasswordModel? _changePassword;
  ChangePasswordModel? get changePassword => _changePassword;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> changingPassword(BuildContext context, String oldPassword,
      String newPassword, String confirmPassword) async {
    final changePasswordRepo = ProfileRepository();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userSession?.userId;

    if (userId == null) {
      debugPrint("User ID is null. Unable to change password.");
      return;
    }

    try {
      isLoading = true;

      _changePassword = await changePasswordRepo.changePassword(
          userId, oldPassword, newPassword, confirmPassword);
      if (_changePassword!.success == true) {
        ToastHelper.showSuccess("${_changePassword!.message}");
        debugPrint("Password changed successfully");
      }else{
        ToastHelper.showError("${_changePassword!.error}");
      }
    } catch (error) {
      debugPrint("Error changing password: $error");
    } finally {
      isLoading = false;
    }
  }

  Future<void> getUserProfileData(context) async {
    try {
      isLoading = true;

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userSession?.userId;

      if (userId == null) {
        debugPrint("Error: User ID is null");
        isLoading = false;
        return;
      }

      _profileModel = await profileRepo.getProfileData(userId);
    } catch (e) {
      debugPrint("Error fetching profile data: $e");
    } finally {
      isLoading = false;
    }
  }

  // Add method to check if a field has changed
  bool _hasFieldChanged(String? newValue, String? oldValue) {
    if (newValue == null || newValue.isEmpty) return false;
    return newValue != oldValue;
  }

  // Add method to prepare update data
  Map<String, dynamic> _prepareUpdateData(
      {String? username,
      String? phone,
      String? address,
      String? currentPassword,
      String? newPassword,
      String? confirmPassword
      }) {
    final Map<String, dynamic> updateData = {};

    if (_hasFieldChanged(username, profileModel?.user?.username)) {
      updateData['username'] = username;
    }
    if (_hasFieldChanged(phone, profileModel?.user?.phone)) {
      updateData['phone'] = phone;
    }
    if (_hasFieldChanged(address, profileModel?.user?.address)) {
      updateData['address'] = address;
    }
    if (currentPassword != null &&
        currentPassword.isNotEmpty &&
        newPassword != null &&
        newPassword.isNotEmpty &&
        confirmPassword != null &&
        confirmPassword.isNotEmpty) {
      updateData['current_password'] = currentPassword;
      updateData['new_password'] = newPassword;
      updateData['confirm_password'] = confirmPassword;
    }

    return updateData;
  }

  // Update the updateProfile method
  Future<void> updateProfile(
    BuildContext context, {
    String? username,
    String? phone,
    String? address,
    String? currentPassword,
    String? newPassword,

  }) async {
    try {
      isLoading = true;

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userSession?.userId;

      if (userId == null) {
        ToastHelper.showError("User ID not found. Please login again.");
        return;
      }

      final updateData = _prepareUpdateData(
        username: username,
        phone: phone,
        address: address,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: newPassword
      );

      if (updateData.isEmpty) {
        ToastHelper.showInfo("No changes to update");
        return;
      }

      // Add user_id to the update data
      updateData['user_id'] = userId;

      debugPrint("Sending update data: $updateData");

      final response = await profileRepo.updateProfileApi(updateData);

      debugPrint("API Response: $response");

      if (response is Map<String, dynamic>) {
        if (response['error'] != null) {
          String errorMessage = response['error'];
          if (errorMessage == "User not found") {
            // Handle session expiration
            ToastHelper.showError("Session expired. Please login again.");
            // You might want to log the user out here
            return;
          } else if (errorMessage == "No valid fields provided for update") {
            // Handle invalid fields
            ToastHelper.showError("Please provide valid information to update");
            return;
          }
        }

        if (response['success'] == true) {
          // Refresh profile data after successful update
          await getUserProfileData(context);
          ToastHelper.showSuccess("Profile updated successfully");
        } else {
          ToastHelper.showError(
              response['message'] ?? "Failed to update profile");
        }
      } else {
        ToastHelper.showError("Invalid response from server");
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      ToastHelper.showError("An error occurred while updating profile");
    } finally {
      isLoading = false;
    }
  }
}
