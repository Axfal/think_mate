// ignore_for_file: avoid_print

import 'package:education_app/resources/exports.dart';
import '../model/mock_test_question_count_model.dart';

class MockTestQuestionCountRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<MockTestQuestionCountModel> getMockTestQuestionCount(
      Map<String, dynamic> data) async {
    try {
      print("Making API request to: ${AppUrl.getMockTestQuestionCount}");
      print("Request data: $data");

      final response = await _apiServices.getPostApiResponse(
          AppUrl.getMockTestQuestionCount, data);

      print("Raw API Response: $response");

      if (response == null) {
        throw Exception("Null response from API");
      }

      final mockTestQuestionCountModel =
          MockTestQuestionCountModel.fromJson(response);
      return mockTestQuestionCountModel;
    } catch (error) {
      print("API Error: $error");
      rethrow;
    }
  }
}
