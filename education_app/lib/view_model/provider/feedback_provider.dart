import 'package:flutter/material.dart';
import '../../main.dart';
import '../../model/feedback_model.dart';
import '../../repository/feedback_repo.dart';

class FeedbackProvider with ChangeNotifier {
  final FeedbackRepository _feedbackRepository = FeedbackRepository();
  FeedbackModel? _feedbackModel;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  FeedbackModel? get feedback => _feedbackModel;

  Future<void> giveFeedback(BuildContext context, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners(); // Notify UI about the loading state

    try {
      _feedbackModel = await _feedbackRepository.giveFeedback(data);
      if (!context.mounted) return;

      String message = _feedbackModel?.message ?? 'Feedback submitted successfully';
      Color color = _feedbackModel?.success == true ? Colors.green : Colors.green;

      _showSnackBar(message, color);
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar('An error occurred: $e', Colors.red);
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI that loading is finished
    }
  }

  Future<void> giveMockTestFeedback(
      BuildContext context, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      _feedbackModel = await _feedbackRepository.giveMockTestFeedback(data);

      if (!context.mounted) return;

      String message =
          _feedbackModel?.message ?? 'Feedback submitted successfully';
      Color color = _feedbackModel?.success == true ? Colors.green : Colors.red;

      _showSnackBar(message, color);
    } catch (e) {
      if (!context.mounted) return;
      _showSnackBar('An error occurred: $e', Colors.red);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showSnackBar(String message, Color color) {
    final scaffoldMessenger = GlobalVariables.scaffoldMessengerKey.currentState;
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(message), backgroundColor: color),
      );
    } else {
      debugPrint("ScaffoldMessenger not found!");
    }
  }
}
