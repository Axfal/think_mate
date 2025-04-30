import 'package:education_app/resources/exports.dart';

import '../model/reset_model.dart';

class ResetRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<ResetModel> fetchQuestions(Map<String, dynamic> data) async {
    try {
      final response =
          await _apiServices.getPostApiResponse(AppUrl.reset, data);

      return ResetModel.fromJson(response);
    } catch (error) {
      debugPrint('Error while resetting the chapter questions: $error');
      throw Exception('Failed to load questions');
    }
  }
}
