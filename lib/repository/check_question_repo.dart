import 'dart:convert';
import 'package:education_app/resources/exports.dart';
import '../model/check_model.dart';
import '../model/get_checked_question_model.dart';

class CheckQuestionRepo {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<CheckModel> checkQuestion(Map<String, dynamic> data) async {
    try {
      debugPrint("Sending Request Data: ${jsonEncode(data)}");

      final response =
          await _apiServices.getPostApiResponse(AppUrl.checkQuestion, data);

      return CheckModel.fromJson(response);
    } catch (error) {
      debugPrint('Error while checking questions: $error');
      throw Exception('Failed to check questions');
    }
  }

  Future<CheckModel> unCheckQuestion(Map<String, dynamic> data) async {
    try {
      debugPrint("Sending Request Data: ${jsonEncode(data)}");

      final response =
          await _apiServices.getPostApiResponse(AppUrl.unCheckQuestion, data);

      return CheckModel.fromJson(response);
    } catch (error) {
      debugPrint('Error while checking questions: $error');
      throw Exception('Failed to check questions');
    }
  }

  Future<GetCheckedQuestionModel> getCheckedQuestion(
      int userId, int testId, int subjectId, int chapterId) async {
    try {
      final response = await _apiServices.getGetApiResponse(
          "${AppUrl.getCheckQuestion}$userId&test_id=$testId&subject_id=$subjectId&chapter_id=$chapterId");
      return GetCheckedQuestionModel.fromJson(response);
    } catch (error, stackTrace) {
      debugPrint('Error while checking questions: $error');
      debugPrint('Stack trace: $stackTrace');
      throw Exception('Failed to check questions');
    }
  }
}
