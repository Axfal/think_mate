import 'package:education_app/model/profile_model.dart';
import 'package:education_app/repository/profile_repo.dart';
import 'package:education_app/resources/exports.dart';

import '../../model/change_password_model.dart';

class ProfileProvider with ChangeNotifier {
  final profileRepo = ProfileRepository();

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  ChangePasswordModel? _changePassword;
  ChangePasswordModel? get changePassword => _changePassword;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> changingPassword(
      BuildContext context, String oldPassword, String newPassword) async {
    final changePasswordRepo = ProfileRepository();
    final authProvider = Provider.of<AuthProvider>(context,listen: false);
    final userId = authProvider.userSession?.userId;

    if (userId == null) {
      debugPrint("User ID is null. Unable to change password.");
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      _changePassword = await changePasswordRepo.changePassword(
          userId, oldPassword, newPassword);
      if(_changePassword!.success == true){
        debugPrint("Password changed successfully");
      }

    } catch (error) {
      debugPrint("Error changing password: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserProfileData(context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userSession?.userId;

      if (userId == null) {
        debugPrint("Error: User ID is null");
        _isLoading = false;
        notifyListeners();
        return;
      }

      _profileModel = await profileRepo.getProfileData(userId);
    } catch (e) {
      debugPrint("Error fetching profile data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
