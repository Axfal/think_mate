// ignore_for_file: avoid_print

import 'package:education_app/model/get_test_result_model.dart';
import 'package:education_app/repository/get_test_result_repo.dart';
import 'package:education_app/resources/exports.dart';

class PreviousTestProvider with ChangeNotifier {
  final _getTestResultRepo = GetTestResultRepository();

  GetTestResultModel? _getTestResultModel;
  bool _isLoading = false;

  GetTestResultModel? get getTestModel => _getTestResultModel;
  bool get isLoading => _isLoading;

  Future<void> getTestData(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userSession?.userId;
    final testId = authProvider.userSession?.testId;

    if (userId == null || testId == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _getTestResultModel =
          await _getTestResultRepo.getTestResult(userId, testId);

      if (_getTestResultModel != null &&
          _getTestResultModel!.examResults != null) {
        for (var exam in _getTestResultModel!.examResults!) {
          if (exam.subjects != null) {
            for (var subject in exam.subjects!) {
              print(subject.subjectName);
            }
          } else {
            print("No subjects found in examResults");
          }
        }
      } else {
        print('No examResults found');
      }
    } catch (e) {
      print("Error fetching test result: $e");
      _getTestResultModel = null; // Ensure null safety
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
