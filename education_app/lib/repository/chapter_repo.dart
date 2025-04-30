import 'package:education_app/resources/exports.dart';

class ChapterRepository {
  final BaseApiServices _apiServices = NetworkApiServices();
  Future<ChapterModel> getChapters(int testId, int subjectId) async {
    try {
      final response = await _apiServices.getGetApiResponse(
          '${AppUrl.fetchChapters}$testId&subject_id=$subjectId');

      if (kDebugMode) {
        print("Raw API Response: $response");
      }

      return ChapterModel.fromJson(response);
    } catch (error) {
      if (kDebugMode) {
        print("API Error: $error");
      }
      rethrow;
    }
  }
}
