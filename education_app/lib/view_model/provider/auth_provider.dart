// ignore_for_file: prefer_const_constructors

import 'package:education_app/resources/exports.dart';
import '../../model/hive_database_model/user_session_model.dart';
import '../../utils/toast_helper.dart';

class AuthProvider with ChangeNotifier {
  final _authRepository = AuthRepository();
  bool _loading = false;
  bool get loading => _loading;

  int? _userId;
  int? get userId => _userId;

  CoursesModel? _courseList;
  CoursesModel? get courseList => _courseList;

  UserSessionModel? _userSession;
  UserSessionModel? get userSession => _userSession;

  Future<void> fetchCoursesList() async {
    if (_courseList != null &&
        _courseList!.data != null &&
        _courseList!.data!.isNotEmpty) {
      if (kDebugMode) {
        print("Courses already fetched. Skipping API call.");
      }
      return;
    }

    try {
      if (kDebugMode) {
        print("Fetching subjects...");
      }

      final response = await _authRepository.setSubject();

      if (response != null) {
        if (kDebugMode) {
          print("Response received: ${response.toJson()}");
        }

        if (response.success == true && response.data != null) {
          _courseList = response;
          _userId = response.toJson()['user_id'] ?? 0;

          if (kDebugMode) {
            print(
                "Subjects list updated successfully: ${_courseList!.data!.length} subjects found");
          }
        } else {
          if (kDebugMode) {
            print("API Response indicates failure: ${response.success}");
          }
        }
      } else {
        if (kDebugMode) {
          print("Error: Response is null.");
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error in subjectsList(): $error");
      }
    }

    notifyListeners();
  }

  Future<void> signIn(context, dynamic data) async {
    _loading = true;
    notifyListeners();
    try {
      final response = await _authRepository.loginApi(data);

      if (response != null && response is Map<String, dynamic>) {
        if (response['success'] == true) {
          var userBox = await Hive.openBox<UserSessionModel>('userBox');
          _userSession = UserSessionModel(
            userId: response['user_id'],
            userType: response['user_type'],
            testId: response['test_id'],
            subscriptionName: response['subscription_name'],
          );
          await userBox.put('session', _userSession!);

          // Navigate to home
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, RoutesName.home);
          }
        } else {
          if (kDebugMode) {
            print(response);
          }
          ToastHelper.showError(response['message'] ??
              response['error'] ??
              response.values.toString());
        }
      } else {
        ToastHelper.showError('Invalid API response');
      }
    } catch (error) {
      ToastHelper.showError(error.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setUserTypeToPremium() {
    if (_userSession != null) {
      _userSession = UserSessionModel(
        userId: _userSession!.userId,
        userType: "premium",
        testId: _userSession!.testId,
        subscriptionName: _userSession!.subscriptionName,
      );

      Hive.openBox<UserSessionModel>('userBox').then((box) {
        box.put('session', _userSession!);
      });

      notifyListeners();
    } else {
      if (kDebugMode) {
        print("User session is null, cannot set userType.");
      }
    }
  }

  void setUserType(String subscriptionName, String userType) {
    if (_userSession != null) {
      _userSession = UserSessionModel(
        userId: _userSession!.userId,
        userType: userType,
        testId: _userSession!.testId,
        subscriptionName: subscriptionName,
      );

      Hive.openBox<UserSessionModel>('userBox').then((box) {
        box.put('session', _userSession!);
      });

      notifyListeners();
    } else {
      if (kDebugMode) {
        print("User session is null, cannot set userType.");
      }
    }
  }

  Future<void> loadUserSession() async {
    var userBox = await Hive.openBox<UserSessionModel>('userBox');
    _userSession = userBox.get('session');
    notifyListeners();
  }

  Future<void> logout() async {
    var userBox = await Hive.openBox<UserSessionModel>('userBox');
    await userBox.delete('session');
    _userSession = null;
    notifyListeners();
  }

  Future<void> signUp(context, data) async {
    _loading = true;
    notifyListeners();
    try {
      if (kDebugMode) {
        print("Signing up with data: $data");
      }
      final response = await _authRepository.signUpApi(data);
      if (kDebugMode) {
        print("Signup API response: $response");
      }
      if (response != null && response is Map<String, dynamic>) {
        if (response['success'] != null) {
          ToastHelper.showSuccess(response['success']);
          if (context.mounted) {
            if (kDebugMode) {
              print("Signup successful, navigating to login screen");
            }
            // Clear all previous screens and navigate to login
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.login,
              (route) => false,
            );
          }
        } else {
          if (kDebugMode) {
            print(
                "API error: ${response['message'] ?? response['error'] ?? response}");
          }
          ToastHelper.showError(response['message'] ??
              response['error'] ??
              response.values.toString());
        }
      } else {
        if (kDebugMode) {
          print("Invalid API response format: $response");
        }
        ToastHelper.showError('Invalid API Response Format');
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error in signUp: $error");
      }
      ToastHelper.showError(error.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> requestResetPassword(context, dynamic data) async {
    _loading = true;
    notifyListeners();
    try {
      if (kDebugMode) {
        print("Requesting password reset for email: ${data['email']}");
      }
      final response = await _authRepository.requestResetPasswordApi(data);
      if (kDebugMode) {
        print("Password reset API response: $response");
      }
      if (response != null && response is Map<String, dynamic>) {
        // Check if the response contains a success message
        if (response['success'] != null) {
          ToastHelper.showSuccess(response['success']);
          if (context.mounted) {
            if (kDebugMode) {
              print(
                  "Navigating to EnterOtpAndResetPasswordScreen with email: ${data['email']}");
            }
            // Clear the current screen and navigate to OTP screen
            Navigator.pushReplacementNamed(
              context,
              RoutesName.enterOtpAndResetPassword,
              arguments: {'email': data['email']},
            );
          }
        } else {
          if (kDebugMode) {
            print(
                "API error: ${response['message'] ?? response['error'] ?? response}");
          }
          ToastHelper.showError(response['message'] ??
              response['error'] ??
              response.values.toString());
        }
      } else {
        if (kDebugMode) {
          print("Invalid API response format: $response");
        }
        ToastHelper.showError('Invalid API Response Format');
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error in requestResetPassword: $error");
      }
      ToastHelper.showError(error.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(context, dynamic data) async {
    _loading = true;
    notifyListeners();
    try {
      if (kDebugMode) {
        print("Resetting password with data: $data");
      }
      final response = await _authRepository.resetPasswordApi(data);
      if (kDebugMode) {
        print("Reset password API response: $response");
      }
      if (response != null && response is Map<String, dynamic>) {
        if (response['success'] != null) {
          ToastHelper.showSuccess(response['success']);
          if (context.mounted) {
            if (kDebugMode) {
              print("Password reset successful, navigating to login screen");
            }
            // Clear all previous screens and navigate to login
            Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.login,
              (route) => false,
            );
          }
        } else {
          if (kDebugMode) {
            print(
                "API error: ${response['message'] ?? response['error'] ?? response}");
          }
          ToastHelper.showError(response['message'] ??
              response['error'] ??
              response.values.toString());
        }
      } else {
        if (kDebugMode) {
          print("Invalid API response format: $response");
        }
        ToastHelper.showError('Invalid API Response Format');
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error in resetPassword: $error");
      }
      ToastHelper.showError(error.toString());
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
