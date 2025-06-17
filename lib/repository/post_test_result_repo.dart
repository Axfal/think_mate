import 'package:education_app/resources/exports.dart';

class PostTestResultRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<PostTestResultModel> postQuestionResult(
      Map<String, dynamic> data) async {
    try {
      final response =
          await _apiServices.getPostApiResponse(AppUrl.postTestResult, data);
      return PostTestResultModel.fromJson(response);
    } catch (error) {
      debugPrint('Error fetching questions: $error');
      throw Exception('Failed to load questions');
    }
  }
}
