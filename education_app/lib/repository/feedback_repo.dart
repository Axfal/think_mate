
import 'package:education_app/resources/exports.dart';

class FeedbackRepository {
  final BaseApiServices _apiServices = NetworkApiServices();
  Future<FeedbackModel> giveFeedback(Map<String, dynamic> data) async {
    try {
      final response =
          await _apiServices.getGetApiResponse(AppUrl.feedback);
      if (kDebugMode) {
        print("Raw API Response: $response");
      }

      return FeedbackModel.fromJson(response);
    } catch (error) {
      if (kDebugMode) {
        print("API Error: $error");
      }
      rethrow;
    }
  }
  Future<FeedbackModel> giveMockTestFeedback(Map<String, dynamic> data) async {
    try {
      final response =
      await _apiServices.getPostApiResponse(AppUrl.mockTestFeedback, data);
      if (kDebugMode) {
        print("Raw API Response: $response");
      }

      return FeedbackModel.fromJson(response);
    } catch (error) {
      if (kDebugMode) {
        print("API Error: $error");
      }
      rethrow;
    }
  }
}
