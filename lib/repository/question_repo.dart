import 'package:education_app/model/validate_user_model.dart';
import 'package:education_app/resources/exports.dart';
import 'package:education_app/resources/model/past_paper_model.dart';

class QuestionRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<MockTestModel> fetchQuestions(Map<String, dynamic> data) async {
    try {
      final response =
          await _apiServices.getPostApiResponse(AppUrl.fetchQuestions, data);

      return MockTestModel.fromJson(response);
    } catch (error) {
      debugPrint('Error fetching questions: $error');
      throw Exception('Failed to load questions');
    }
  }

  Future<PastPaperModel> pastPaperTest(Map<String, dynamic> data) async {
    try {
      final response =
          await _apiServices.getPostApiResponse(AppUrl.pastPaperQuestion, data);

      return PastPaperModel.fromJson(response);
    } catch (error) {
      debugPrint('Error fetching questions: $error');
      throw Exception('Failed to load questions');
    }
  }

  Future<ValidateUserModel> validateUser(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.getPostApiResponse(
        AppUrl.validateUserForMockTest,
        data,
      );
      return ValidateUserModel.fromJson(response);
    } catch (error) {
      debugPrint('Error validating user: $error');
      throw Exception('Failed to validate user');
    }
  }
}
