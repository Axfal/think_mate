import 'package:education_app/resources/exports.dart';
import 'package:education_app/model/subscription_histroy_model.dart';

/// A widget that displays a payment history card with payment details and status.
///
/// This widget shows payment information including subscription name, test name,
/// payment date, amount, and status. It also provides functionality to view
/// the payment image in a full-screen dialog.
class PaymentHistoryCard extends StatelessWidget {
  final PaymentHistory history;

  const PaymentHistoryCard({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final status = history.status ?? 'pending';
    final isApproved = status.toLowerCase() == 'approved';
    final imageUrl =
        "https://nomore.com.pk/MDCAT_ECAT_Education/API/${history.paymentImage}";

    return GestureDetector(
      onTap: () => _showPaymentImage(context, imageUrl),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.purpleShadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: _buildPaymentImage(imageUrl),
          title: Text(
            "${history.subscriptionName ?? "Subscription"} - ${history.testName ?? "Test"}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text("Date: ${history.paymentDate ?? "--"}"),
              const SizedBox(height: 4),
              Text("Amount: Rs. ${history.amount ?? "0"}"),
            ],
          ),
          trailing: _buildStatusBadge(status, isApproved),
        ),
      ),
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
        errorBuilder: (context, _, __) =>
            const Icon(Icons.image_not_supported, size: 60),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isApproved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isApproved
            ? AppColors.successColor.withOpacity(0.1)
            : AppColors.warningColor.withOpacity(0.1),
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
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Payment Image',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
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
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, _, __) =>
                          const Icon(Icons.image_not_supported, size: 80),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.whiteColor,
                  backgroundColor: AppColors.deepPurple,
                ),
                child: Text(
                  "Close",
                  style: AppTextStyle.bodyText1.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
