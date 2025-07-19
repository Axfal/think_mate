// ignore_for_file: avoid_print

import 'package:education_app/model/current_plan_model.dart';
import 'package:education_app/model/verify_promo_model.dart';
import 'package:education_app/resources/exports.dart';

class SubscriptionProvider with ChangeNotifier {
  final _subscription = SubscriptionRepo();

  GetSubscriptionModel? _getSubscriptionModel;
  GetSubscriptionModel? get getSubscriptionModel => _getSubscriptionModel;

  CurrentPlanModel? _currentPlanModel;
  CurrentPlanModel? get currentPlanModel => _currentPlanModel;

  PostSubscriptionModel? _postSubscriptionModel;
  PostSubscriptionModel? get postSubscriptionModel => _postSubscriptionModel;

  SubscriptionHistoryModel? _subscriptionHistoryModel;
  SubscriptionHistoryModel? get subscriptionHistoryModel =>
      _subscriptionHistoryModel;

  CheckUserSubscriptionPlanModel? _checkUserSubscriptionPlanModel;
  CheckUserSubscriptionPlanModel? get checkUserSubscriptionPlanModel =>
      _checkUserSubscriptionPlanModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool get hasSubscription => _getSubscriptionModel != null;

  VerifyPromoModel? _verifyPromoCodeModel;
  VerifyPromoModel? get verifyPromoCodeModel => _verifyPromoCodeModel;

  /// check user plan
  Future<void> getUserSubscriptionPlan(context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    await provider.loadUserSession();
    final userId = provider.userSession?.userId;
    if (userId == null) {
      print("User ID is null. Cannot fetch subscription plan.");
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await _subscription.checkSubscriptionPlan(userId: userId);
      if (response != null && response["success"] == true) {
        _checkUserSubscriptionPlanModel =
            CheckUserSubscriptionPlanModel.fromJson(response);
      }
    } catch (e) {
      print("the error occur while fetching user subscription plan: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch subscription plan and user current plan
  Future<void> getSubscription({int? testId, int? userId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (testId != null) {
        final response = await _subscription.getSubscription(testId: testId);

        if (response is Map<String, dynamic> &&
            response['success'] == true &&
            response['subscriptions'] != null) {
          _getSubscriptionModel = GetSubscriptionModel.fromJson(response);
        } else {
          _getSubscriptionModel = null;
          debugPrint('Failed to load subscriptions or "success" key missing.');
        }
      } else {
        final response = await _subscription.getSubscription(userId: userId);

        if (response is Map<String, dynamic> &&
            response['success'] == true &&
            response['subscriptions'] != null) {
          _currentPlanModel = CurrentPlanModel.fromJson(response);
        } else {
          debugPrint('Failed to load subscriptions or "success" key missing.');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching subscription: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSubscriptionHistory(context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    await provider.loadUserSession();
    final userId = provider.userSession!.userId;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _subscription.getSubscriptionHistory(userId);
      if (response.success == true && response.paymentHistory != null) {
        _subscriptionHistoryModel = response;
        if (_subscriptionHistoryModel!.paymentHistory!.last.status ==
            "approved") {
          provider.setUserTypeToPremium();
        }
      } else {
        _error = 'Failed to load payment history';
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching subscription history: $e');
      debugPrintStack(stackTrace: stackTrace);
      _error = 'Failed to load payment history. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> postSubscription(
      context,
      String testId,
      String subscriptionId,
      String amount,
      String date,
      File screenshotImage,
      String promoCode) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    await provider.loadUserSession();
    final userId = provider.userSession!.userId.toString();
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _subscription.postSubscription(
          userId: userId,
          testId: testId,
          subscriptionId: subscriptionId,
          amount: amount,
          date: date,
          screenshotImage: screenshotImage,
          promoCode: promoCode);
      if (response.success == true && response.message != null) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("${response.message}"),
        //   backgroundColor: Colors.red,
        // ));
        _postSubscriptionModel = response;
        _verifyPromoCodeModel = null;
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("error: $e"),
        backgroundColor: Colors.red,
      ));
      debugPrint('Error posting subscription: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyPromoCode(context, String promoCode) async {
    Map<String, dynamic> data = {"promo_code": promoCode};

    // _isLoading = true;
    // notifyListeners();

    try {
      final response = await _subscription.verifyPromoCode(data);

      if (response != null && response["success"] == true) {
        _verifyPromoCodeModel = VerifyPromoModel.fromJson(response);
        ToastHelper.showSuccess(
            "You got a discount of Rs. ${response["data"]["discount"]}");
      } else {
        ToastHelper.showError(response?["error"] ?? "Promo Code is not valid");
      }
    } catch (e) {
      print("Error verifying promo code: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
