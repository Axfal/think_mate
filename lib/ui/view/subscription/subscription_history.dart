import 'package:education_app/resources/exports.dart';

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
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    if (!_hasLoadedOnce) {
      _loadPaymentHistory();
      _hasLoadedOnce = true;
    }
  }

  Future<void> _loadPaymentHistory() async {
    try {
      final provider =
          Provider.of<SubscriptionProvider>(context, listen: false);
      await provider.getSubscriptionHistory(context);
    } catch (e) {
      if (mounted) {
        ToastHelper.showError('Failed to load payment history');
      }
      debugPrint('Error loading payment history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _loadPaymentHistory,
        color: AppColors.whiteColor,
        backgroundColor: AppColors.indigo,
        child: _buildBody(),
      ),
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
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, color: AppColors.whiteColor),
      ),
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
    );
  }

  Widget _buildBody() {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const SubscriptionHistoryShimmer();
        }

        if (provider.error != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPullToRefreshHint(),
              Expanded(child: _buildErrorState(provider.error!)),
            ],
          );
        }

        final paymentHistory =
            provider.subscriptionHistoryModel?.paymentHistory ?? [];

        if (paymentHistory.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPullToRefreshHint(),
              Expanded(child: _buildEmptyState()),
            ],
          );
        }

        return Column(
          children: [
            _buildPullToRefreshHint(),
            Expanded(child: _buildPaymentList(paymentHistory)),
          ],
        );
      },
    );
  }

  Widget _buildPullToRefreshHint() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_downward, size: 18, color: AppColors.greyText),
          const SizedBox(width: 6),
          Text(
            'Pull down to refresh',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.greyText,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            "Something went wrong",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.errorColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyText,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadPaymentHistory,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepPurple,
              foregroundColor: AppColors.whiteColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
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
      itemBuilder: (_, index) => SubscriptionHistoryCard(
        history: paymentHistory[index],
      ),
    );
  }
}
