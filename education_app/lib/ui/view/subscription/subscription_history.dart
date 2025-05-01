import 'package:education_app/resources/exports.dart';
import 'package:education_app/ui/widgets/payment_history_card.dart';
import 'package:education_app/ui/widgets/payment_history_shimmer.dart';
import 'package:education_app/view_model/provider/subscription_provider.dart';
import 'package:education_app/model/subscription_histroy_model.dart';

/// A screen that displays the user's subscription payment history.
///
/// This screen shows a list of all payments made by the user for subscriptions,
/// including payment details, status, and the ability to view payment receipts.
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  void _loadPaymentHistory() async {
    final provider = Provider.of<SubscriptionProvider>(context, listen: false);
    await provider.getSubscriptionHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        "Subscription History",
        style: AppTextStyle.heading3.copyWith(
          color: AppColors.whiteColor,
        ),
      ),
      backgroundColor: AppColors.deepPurple,
      foregroundColor: AppColors.whiteColor,
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const PaymentHistoryShimmer();
        }

        final paymentHistory =
            provider.subscriptionHistoryModel?.paymentHistory ?? [];

        if (paymentHistory.isEmpty) {
          return _buildEmptyState();
        }

        return _buildPaymentList(paymentHistory);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppColors.greyText,
          ),
          const SizedBox(height: 16),
          Text(
            "No payment history found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.greyText,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your subscription payments will appear here",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyText,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentList(List<PaymentHistory> paymentHistory) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: paymentHistory.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, index) => PaymentHistoryCard(
        history: paymentHistory[index],
      ),
    );
  }
}
