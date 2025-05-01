// import 'dart:convert';

import 'package:education_app/resources/exports.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.signIn, data);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> signUpApi(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.signUp, data);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<CoursesModel?> setSubject() async {
    try {
      if (kDebugMode) {
        print("Fetching API...");
      }

      dynamic response = await _apiServices.getGetApiResponse(AppUrl.fetchTest);

      if (kDebugMode) {
        print("Raw API Response: $response");
      } // Debugging

      if (response is Map<String, dynamic>) {
        return CoursesModel.fromJson(response);
      } else {
        if (kDebugMode) {
          print("Unexpected response type: ${response.runtimeType}");
        }
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error in API: $error");
      }
      return null;
    }
  }

  Future<dynamic> requestResetPasswordApi(dynamic data) async {
    try {
      if (kDebugMode) {
        print("Requesting OTP for email: ${data['email']}");
      }
      dynamic response = await _apiServices.getPostApiResponse(
          AppUrl.requestResetPassword, data);
      if (kDebugMode) {
        print("OTP Request Response: $response");
      }
      return response;
    } catch (error) {
      if (kDebugMode) {
        print("Error in requestResetPasswordApi: $error");
      }
      rethrow;
    }
  }

  Future<dynamic> resetPasswordApi(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(
          '${AppUrl.baseUrl}/reset_password.php', data);
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
