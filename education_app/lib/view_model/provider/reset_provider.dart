// ignore_for_file: unnecessary_string_interpolations

import 'package:education_app/model/reset_model.dart';
import 'package:education_app/repository/reset_repo.dart';
import 'package:education_app/resources/exports.dart';

class ResetProvider with ChangeNotifier {
  final resetRepo = ResetRepository();

  ResetModel? _resetModel;
  ResetModel? get resetModel => _resetModel;

  Future<void> resetQuestions(BuildContext context, int chapterId) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userSession?.userId;
      final testId = authProvider.userSession?.testId;

      Map<String, dynamic> data = {
        "user_id": userId,
        "test_id": testId,
        "chapter_id": chapterId
      };

      _resetModel = await resetRepo.fetchQuestions(data);
      notifyListeners();

      if (context.mounted) {
        if (_resetModel != null) {
          if (_resetModel!.success == true && _resetModel!.message != null) {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(_resetModel!.message!),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(_resetModel!.message ?? "An error occurred."),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text("Failed to reset questions. Please try again."),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Error: $e"),
          ),
        );
      }
      debugPrint("Reset Questions API Error: $e");
      rethrow;
    }
  }
}
