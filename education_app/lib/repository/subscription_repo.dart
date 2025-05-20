import 'package:education_app/resources/exports.dart';
import 'package:http/http.dart' as http;

class SubscriptionRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  /// Fetch subscription plans (GET)
  Future<GetSubscriptionModel> getSubscription() async {
    try {
      final response =
          await _apiServices.getGetApiResponse(AppUrl.getSubscription);

      if (kDebugMode) {
        print("GET Subscription Response: $response");
      }

      return GetSubscriptionModel.fromJson(response);
    } catch (error) {
      if (kDebugMode) {
        print("GET Subscription Error: $error");
      }
      rethrow;
    }
  }

  /// Fetch subscription plans (GET)
  Future<SubscriptionHistoryModel> getSubscriptionHistory(int userId) async {
    try {
      print("the user id in repo: $userId");
      final response = await _apiServices
          .getGetApiResponse("${AppUrl.getSubscriptionHistory}$userId");

      if (kDebugMode) {
        print("GET Subscription Response: $response");
      }

      return SubscriptionHistoryModel.fromJson(response);
    } catch (error) {
      if (kDebugMode) {
        print("GET Subscription Error: $error");
      }
      rethrow;
    }
  }

  /// Post subscription data (multipart/form-data)
  Future<PostSubscriptionModel> postSubscription(
      {required String userId,
      required String testId,
      required String subscriptionId,
      required String amount,
      required String date,
      required File screenshotImage,
      required String promoCode}) async {
    try {
      final data = <String, dynamic>{
        'user_id': userId,
        'test_id': testId,
        'subscription_id': subscriptionId,
        'amount': amount,
        'payment_date': date,
        "promo_code": promoCode,
        'payment_image': await http.MultipartFile.fromPath(
            'payment_image', screenshotImage.path),
      };

      // Send the multipart request
      final response = await _apiServices.getPostMultipartRequestApiResponse(
        AppUrl.postSubscription,
        data,
      );

      if (kDebugMode) {
        print("POST Subscription Raw Response: $response");
      }

      return PostSubscriptionModel.fromJson(response);
    } catch (error) {
      if (kDebugMode) {
        print("POST Subscription Error: $error");
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> checkSubscriptionPlan({
    required int userId,
  }) async {
    try {
      final data = <String, dynamic>{'user_id': userId};

      // Send the user ID to check the user subscription plan
      final response = await _apiServices.getPostApiResponse(
        AppUrl.checkSubscriptionPlan,
        data,
      );

      if (kDebugMode) {
        print("POST Subscription Raw Response: $response");
      }

      return response;
    } catch (error) {
      if (kDebugMode) {
        print("POST Subscription Error: $error");
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> verifyPromoCode(dynamic data) async {
    try {
      final response =
          await _apiServices.getPostApiResponse(AppUrl.verifyPromoCode, data);

      if (response != null && response["success"] == true) {
        return response;
      } else {
        return {
          "success": false,
        };
      }
    } catch (e) {
      rethrow;
    }
  }
}
