// ignore_for_file: avoid_print

import 'dart:io';

import 'package:education_app/model/check_user_subscription_plan_model.dart';
import 'package:education_app/model/post_subscription_model.dart';
import 'package:education_app/model/subscription_histroy_model.dart';
import 'package:education_app/resources/exports.dart';

class SubscriptionProvider with ChangeNotifier {
  final _subscription = SubscriptionRepo();

  GetSubscriptionModel? _getSubscriptionModel;
  GetSubscriptionModel? get getSubscriptionModel => _getSubscriptionModel;

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

  bool get hasSubscription => _getSubscriptionModel != null;

  Future<void> getUserSubscriptionPlan(context) async{
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
      final response = await _subscription.checkSubscriptionPlan(userId: userId);
      if(response != null && response["success"] == true){
        _checkUserSubscriptionPlanModel = CheckUserSubscriptionPlanModel.fromJson(response);
      }

    }catch(e){
      print("the error occur while fetching user subscription plan: $e");
    }finally{
      _isLoading = false;
      notifyListeners();
    }

  }

  Future<void> getSubscription() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _subscription.getSubscription();
      if (response.success == true && response.subscriptions != null) {
        _getSubscriptionModel = response;
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
    print("asjdlka ===?> $userId");
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _subscription.getSubscriptionHistory(userId);
      if (response.success == true && response.paymentHistory != null) {
        _subscriptionHistoryModel = response;
        if (_subscriptionHistoryModel!.paymentHistory!.last.status ==
            "approved") {
          provider.setUserTypeToPremium();
        }
        notifyListeners();
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching subscription history: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
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
  ) async {
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
      );
      if (response.success == true && response.message != null) {
        _postSubscriptionModel = response;
      }
    } catch (e, stackTrace) {
      debugPrint('Error posting subscription: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
