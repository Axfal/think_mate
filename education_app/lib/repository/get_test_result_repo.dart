import 'package:education_app/resources/exports.dart';
import '../model/get_test_result_model.dart';

class GetTestResultRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<GetTestResultModel> getTestResult(int userId, int testId) async {
    try {
      final response = await _apiServices
          .getGetApiResponse("${AppUrl.getTestResult}$userId&test_id=$testId");
      return GetTestResultModel.fromJson(response);
    } catch (error, stackTrace) {
      debugPrint('Error fetching test results: $error');
      debugPrint('Stack trace: $stackTrace');

      throw Exception('Failed to fetch test results. Please try again later.');
    }
  }
}
