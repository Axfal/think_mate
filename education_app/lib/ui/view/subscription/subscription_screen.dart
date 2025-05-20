// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:education_app/model/hive_database_model/user_session_model.dart';
import 'package:education_app/resources/exports.dart';
import 'package:education_app/ui/view/subscription/payment_screen.dart';
import 'package:education_app/ui/view/subscription/subscription_history.dart';
import 'package:education_app/ui/widgets/subscription_card.dart';
import 'package:education_app/ui/widgets/subscription_shimmer.dart';
import 'package:flutter/services.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String? currentSubscriptionName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadUserSubscription();
      _loadSubscriptions();
    });
  }

  void _showPaymentDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Icon(Icons.account_balance_wallet, color: AppColors.primaryColor),
              SizedBox(width: 10),
              Text("Payment Details",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildPaymentTile(
                  title: "Easypaisa",
                  name: "Toheed Ahmad",
                  detail: "0332 6984463",
                  context: context,
                ),
                SizedBox(height: 10),
                _buildPaymentTile(
                  title: "JazzCash",
                  name: "Tauheed Ahmad",
                  detail: "0314 6588261",
                  context: context,
                ),
                SizedBox(height: 10),
                _buildPaymentTile(
                  title: "Bank Alfalah Limited",
                  name: "Tusif Ahmad",
                  detail: "PK04ALFH0358001006064601",
                  context: context,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close",
                  style: TextStyle(color: AppColors.primaryColor)),
            )
          ],
        );
      },
    );
  }

  Future<void> _loadUserSubscription() async {
    var userBox = await Hive.openBox<UserSessionModel>('userBox');
    final userSession = userBox.get('session');
    setState(() {
      currentSubscriptionName = userSession?.subscriptionName;
    });
  }

  void _loadSubscriptions() async {
    final provider = Provider.of<SubscriptionProvider>(context, listen: false);
    await provider.getSubscription();
  }

  void _navigateToPaymentScreen(subscription) {
    final month = subscription.months ?? 1;
    final price = subscription.price ?? 2000;
    final subscriptionId = subscription.id;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadPaymentScreen(
          month: month,
          price: price,
          subscriptionId: subscriptionId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.deepPurple.withValues(alpha: 0.1),
              AppColors.lightPurple.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSubscriptionList(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Subscription Plans',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.whiteColor,
            ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
      ),
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.deepPurple,
              AppColors.lightPurple,
            ],
          ),
        ),
      ),
      actions: [
        // IconButton(onPressed: () => _showPaymentDetailsDialog(context), icon: Icon(Icons.payment_rounded)),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: AppColors.whiteColor),
          onSelected: (value) {
            if (value == 'Subscription History') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentHistoryScreen(),
                ),
              );
            }
            if (value == 'Payment Method') {
              _showPaymentDetailsDialog(context);
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 'Subscription History',
              child: Text(
                'Subscription History',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            PopupMenuItem(
              value: 'Payment Method',
              child: Text(
                'Payment Method',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Plan',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 8),
          Text(
            'Select the perfect subscription plan for your needs',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyText,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionList() {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        final subscriptions = provider.getSubscriptionModel?.subscriptions;

        if (subscriptions == null) {
          return const SubscriptionShimmer();
        }

        if (subscriptions.isEmpty) {
          return Center(
            child: Text(
              "No subscription plans available",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subscriptions.length,
          itemBuilder: (context, index) {
            final subscription = subscriptions[index];
            final startDate = provider
                    .checkUserSubscriptionPlanModel?.subscriptionStartDate ??
                "...";
            final expireDate =
                provider.checkUserSubscriptionPlanModel?.subscriptionEndDate ??
                    "...";
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            authProvider.loadUserSession();
            final userType = authProvider.userSession!.userType;

            return SubscriptionCard(
              title: subscription.subscriptionName!,
              price: "Rs. ${subscription.price}",
              duration: "${subscription.months} Month",
              startDate: startDate,
              endDate: expireDate,
              userType: userType,
              isRecommended:
                  currentSubscriptionName == subscription.subscriptionName,
              features: const [
                "Unlimited Quizzes",
                "Ad-Free Experience",
                "Exclusive Learning Content",
                "Progress Tracking"
              ],
              onTap: () {
                if (subscription.subscriptionName == "Free Plan") {
                  Navigator.pop(context);
                } else {
                  _navigateToPaymentScreen(subscription);
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentTile({
    required String title,
    required String name,
    required String detail,
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.person, size: 18, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(name, style: TextStyle(fontSize: 15)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone_android, size: 18, color: Colors.grey[600]),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  detail,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: detail));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Copied $title number"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      Icon(Icons.copy, size: 18, color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
