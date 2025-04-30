import 'dart:convert';

import 'package:education_app/model/incorrect_questions_model.dart';
import 'package:education_app/resources/exports.dart';

class IncorrectQuestionRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<IncorrectQuestionModel> fetchIncorrectQuestions(Map<String, dynamic> data) async {
    try {
      debugPrint("Sending Request Data: ${jsonEncode(data)}"); // Log data

      final response = await _apiServices.getPostApiResponse(
        AppUrl.incorrectQuestions,
        data
      );

      return IncorrectQuestionModel.fromJson(response);
    } catch (error) {
      debugPrint('Error fetching questions: $error');
      throw Exception('Failed to load questions');
    }
  }

}
