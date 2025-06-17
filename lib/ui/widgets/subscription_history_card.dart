import 'package:education_app/resources/exports.dart';

/// A widget that displays a payment history card with payment details and status.
///
/// This widget shows payment information including subscription name, test name,
/// payment date, amount, and status. It also provides functionality to view
/// the payment image in a full-screen dialog.


class SubscriptionHistoryCard extends StatelessWidget {
  final PaymentHistory history;

  const SubscriptionHistoryCard({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final status = history.status?.toLowerCase() ?? 'pending';
    final isApproved = status == 'approved';
    final imageUrl = _buildImageUrl(history.paymentImage);

    return Card(
      elevation: 4,
      shadowColor: AppColors.purpleShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showPaymentImage(context, imageUrl),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPaymentImage(imageUrl),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _buildTitle(),
                      style: AppTextStyle.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPaymentDetails(),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildStatusBadge(status, isApproved),
            ],
          ),
        ),
      ),
    );
  }

  String _buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    return "https://nomore.com.pk/MDCAT_ECAT_Education/API/$imagePath";
  }

  String _buildTitle() {
    final subscriptionName = history.subscriptionName ?? "Subscription";
    final testName = history.testName ?? "Test";
    return "$subscriptionName - $testName";
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          Icons.calendar_today,
          "Date ${history.paymentDate ?? "--"}",
        ),
        const SizedBox(height: 4),
        _buildDetailRow(
          Icons.payment,
          "Amount: Rs. ${history.amount ?? "0"}",
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.greyText,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: AppTextStyle.bodyText2.copyWith(
              color: AppColors.greyText,
            ),
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, _, __) => Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.greyText.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.image_not_supported,
            size: 30,
            color: AppColors.greyText,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isApproved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isApproved
            ? AppColors.successColor.withValues(alpha: 0.1)
            : AppColors.warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyle.bodyText2.copyWith(
          fontWeight: FontWeight.bold,
          color: isApproved ? AppColors.successColor : AppColors.warningColor,
        ),
      ),
    );
  }

  void _showPaymentImage(BuildContext context, String imageUrl) {
    if (imageUrl.isEmpty) {
      ToastHelper.showError('Payment image not available');
      return;
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Payment Image',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, _, __) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: AppColors.greyText,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Failed to load image',
                              style: AppTextStyle.bodyText1.copyWith(
                                color: AppColors.greyText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepPurple,
                  foregroundColor: AppColors.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Ok'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
