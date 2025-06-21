// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';

import 'package:education_app/resources/exports.dart' hide Data;
import '../../model/get_user_test_data_session_model.dart';
import '../../model/hive_database_model/submitted_questions_model.dart';
import '../../model/hive_database_model/user_session_model.dart';

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

          await getUserTestData();

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

  void setUserType(String subscriptionName, String userType, int testId) {
    if (_userSession != null) {
      _userSession = UserSessionModel(
        userId: _userSession!.userId,
        userType: userType,
        testId: testId,
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

      // Validate data before making API call
      if (data['email'] == null || data['email'].toString().isEmpty) {
        throw Exception('Email is required');
      }
      if (data['otp'] == null || data['otp'].toString().isEmpty) {
        throw Exception('OTP is required');
      }
      if (data['password'] == null || data['password'].toString().isEmpty) {
        throw Exception('Password is required');
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
          String errorMessage = response['message'] ??
              response['error'] ??
              'Failed to reset password. Please try again.';
          if (kDebugMode) {
            print("API error: $errorMessage");
          }
          ToastHelper.showError(errorMessage);
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

  Future<void> postUserTestData() async {
    _loading = true;
    notifyListeners();

    try {
      // Open the Hive box
      final box = Hive.box<SubmittedQuestionsModel>('submittedQuestionsBox');

      // Prepare the results list
      final List<Map<String, dynamic>> results = box.values.map((question) {
        return {
          "questionId": question.questionId,
          "questionResult": question.questionResult,
          "selectedOption": question.selectedOption,
          "chapterId": question.chapterId,
        };
      }).toList();

      // Extract userId from session
      final int? userId = _userSession?.userId;

      if (userId == null) {
        print("User ID not found in session.");
        ToastHelper.showError("User ID not found. Please login again.");
        return;
      }

      final Map<String, dynamic> payload = {
        "user_id": userId,
        "results": results,
      };

      // Send POST request
      final response = await _authRepository.postUserTestData(payload);

      if (response != null && response['success'] == true) {
        print("User data submitted successfully.");
        ToastHelper.showSuccess("Logout successfully!");
      } else {
        print("Server error: ${response.statusCode} - ${response.body}");
        ToastHelper.showError("Failed to post data.");
      }
    } catch (e) {
      print("Exception: $e");
      ToastHelper.showError("Error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> getUserTestData() async {
    _loading = true;
    notifyListeners();

    try {
      final int? userId = _userSession?.userId;

      if (userId == null) {
        print("User ID not found in session.");
        ToastHelper.showError("User ID not found. Please login again.");
        return;
      }

      final response = await _authRepository.getUserTestData(userId);

      if (response != null && response['success'] == true) {
        final UserTestDataModel userTestDataModel = UserTestDataModel.fromJson(response);

        final box = await Hive.openBox<SubmittedQuestionsModel>('submittedQuestionsBox');

        await box.clear();

        /// Store in Hive
        for (final Data item in userTestDataModel.data ?? []) {
          final submittedQuestion = SubmittedQuestionsModel(
            questionId: item.questionId ?? 0,
            chapterId: item.chapterId ?? 0,
            questionResult: item.questionResult ?? '',
            selectedOption: item.selectedOption ?? 0,
          );
          await box.add(submittedQuestion);
        }

        print("User test data saved to Hive successfully.");
      } else {
        print("Failed to fetch user test data. Response: $response");
        ToastHelper.showError("Failed to fetch test data.");
      }
    } catch (e) {
      print("Error in getUserTestData(): $e");
      ToastHelper.showError("Error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

}
