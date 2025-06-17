import 'package:flutter/material.dart';
import '../../main.dart';
import '../../model/feedback_model.dart';
import '../../repository/feedback_repo.dart';
import '../../utils/toast_helper.dart';

class FeedbackProvider with ChangeNotifier {
  final FeedbackRepository _feedbackRepository = FeedbackRepository();
  FeedbackModel? _feedbackModel;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  FeedbackModel? get feedback => _feedbackModel;

  Future<void> giveFeedback(
      BuildContext context, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      _feedbackModel = await _feedbackRepository.giveFeedback(data);
      if (!context.mounted) return;

      String message =
          _feedbackModel?.message ?? 'Feedback submitted successfully';
      debugPrint(
          'Feedback API response: \\_feedbackModel: \\${_feedbackModel?.toJson()}');
      debugPrint('Feedback success value: \\${_feedbackModel?.success}');
      if (_feedbackModel?.success == true) {
        ToastHelper.showSuccess(message);
      } else {
        ToastHelper.showError(message);
      }
    } catch (e) {
      if (!context.mounted) return;
      ToastHelper.showError('An error occurred: $e');
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
      if (_feedbackModel?.success == true) {
        ToastHelper.showSuccess(message);
      } else {
        ToastHelper.showError(message);
      }
    } catch (e) {
      if (!context.mounted) return;
      ToastHelper.showError('An error occurred: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
