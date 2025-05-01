// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:education_app/model/hive_database_model/user_session_model.dart';
import 'package:education_app/resources/exports.dart';
import 'package:education_app/ui/view/subscription/payment_screen.dart';
import 'package:education_app/ui/view/subscription/subscription_history.dart';
import 'package:education_app/ui/widgets/subscription_card.dart';
import 'package:education_app/ui/widgets/subscription_shimmer.dart';
import 'package:education_app/view_model/provider/subscription_provider.dart';

/// The main subscription screen that displays available subscription plans.
///
/// This screen shows a list of subscription plans with their features and pricing.
/// It also provides navigation to subscription history and payment screens.
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
              AppColors.deepPurple.withOpacity(0.1),
              AppColors.lightPurple.withOpacity(0.05),
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
      backgroundColor: AppColors.deepPurple,
      elevation: 0,
      actions: [
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
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 'Subscription History',
              child: Text(
                'Subscription History',
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
            return SubscriptionCard(
              title: subscription.subscriptionName!,
              price: "Rs. ${subscription.price}",
              duration: "${subscription.months} Month",
              isRecommended: currentSubscriptionName == subscription.subscriptionName,
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
}
