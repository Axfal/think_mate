import 'package:education_app/resources/exports.dart';

class SubjectsRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<SubjectModel?> getCourses(int num) async {
    final testId = num.toString();
    print("in repo the testID is $testId");
    try {
      dynamic response = await _apiServices
          .getGetApiResponse(AppUrl.fetchSubjects + testId);

      if (kDebugMode) {
        print("Raw API Response: $response");
      }

      if (response is Map<String, dynamic>) {
        return SubjectModel.fromJson(response);
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
}
