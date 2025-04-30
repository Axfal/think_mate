import 'package:education_app/resources/exports.dart';
import 'package:education_app/view_model/provider/subscription_provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../model/subscription_histroy_model.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final provider = Provider.of<SubscriptionProvider>(context, listen: false);
    await provider.getSubscriptionHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubscriptionProvider>(context);
    final isLoading = provider.isLoading;
    final paymentHistory =
        provider.subscriptionHistoryModel?.paymentHistory ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Subscription History", style: AppTextStyle.appBarText),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: isLoading
          ? _buildShimmerList()
          : paymentHistory.isEmpty
              ? const Center(child: Text("No payment history found"))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: paymentHistory.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final history = paymentHistory[index];
                    return _buildHistoryCard(context, history);
                  },
                ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, PaymentHistory history) {
    final status = history.status ?? 'pending';
    final isApproved = status.toLowerCase() == 'approved';
    final imageUrl =
        "https://nomore.com.pk/MDCAT_ECAT_Education/API/${history.paymentImage}";

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            insetPadding: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text("Close"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, _, __) =>
                  const Icon(Icons.image_not_supported, size: 60),
            ),
          ),
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
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:
                  isApproved ? Colors.green.shade100 : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isApproved ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: ShimmerWidget.rectangular(
                width: 60, height: 60, borderRadius: 8),
            title: ShimmerWidget.rectangular(height: 16, width: 200),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 8),
                ShimmerWidget.rectangular(height: 14, width: 120),
                SizedBox(height: 4),
                ShimmerWidget.rectangular(height: 14, width: 100),
              ],
            ),
            trailing: ShimmerWidget.rectangular(
                width: 60, height: 20, borderRadius: 12),
          ),
        );
      },
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerWidget.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
