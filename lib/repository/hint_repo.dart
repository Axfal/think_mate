import 'package:education_app/resources/exports.dart';

class HintRepo {
  final _service = NetworkApiServices();

  /// general hint section
  Future<dynamic> generalHint(int testId) async {
    dynamic response =
        await _service.getGetApiResponse("${AppUrl.generalHint}$testId");
    return response;
  }

  /// subjective hint section
  Future<dynamic> subjectiveHint(int testId, int subjectId) async {
    dynamic response = await _service.getGetApiResponse(
        "${AppUrl.subjectiveHint}$testId&subject_id=$subjectId");
    return response;
  }
}
