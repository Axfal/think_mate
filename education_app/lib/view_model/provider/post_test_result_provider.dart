import 'package:education_app/repository/post_test_result_repo.dart';
import 'package:education_app/resources/exports.dart';

class PostTestResultProvider with ChangeNotifier {
  final _postTestResult = PostTestResultRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> postTestResult(
      context, List<Map<String, dynamic>> questions) async {
    _isLoading = true;
    notifyListeners();

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userSession!.userId;
      final testId = authProvider.userSession!.testId;

      Map<String, dynamic> data = {
        "user_id": userId,
        "test_id": testId,
        "questions": questions
      };

      await _postTestResult.postQuestionResult(data);
    } catch (e) {
      debugPrint("Error posting test result: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
