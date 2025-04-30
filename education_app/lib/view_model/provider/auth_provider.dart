// ignore_for_file: prefer_const_constructors

import 'package:education_app/resources/exports.dart';
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

          // Navigate to home
          Navigator.pushReplacementNamed(context, RoutesName.home);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('SignIn Successfully'),
                backgroundColor: AppColors.primaryColor),
          );
        } else {
          if (kDebugMode) {
            print(response);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'SignIn Failed: ${response['message'] ?? "$response"}'),
                backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Invalid API response'),
              backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: ${error.toString()}'),
            backgroundColor: Colors.red),
      );
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
      final response = await _authRepository.signUpApi(data);
      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('success') && response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('SignUp Successfully'),
                backgroundColor: AppColors.primaryColor),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response.values
                    .toString()), //'Signup Failed: ${response['error']}'),
                backgroundColor: AppColors.primaryColor),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Invalid API Response Format'),
              backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: ${error.toString()}'),
            backgroundColor: Colors.red),
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
